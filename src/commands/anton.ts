import fs from "node:fs/promises";
import path from "node:path";
import type { CliDeps } from "../cli/deps.js";
import type { RuntimeEnv } from "../runtime.js";
import { CONFIG_DIR } from "../utils.js";

type ParsedTask = {
  line: number;
  indent: string;
  text: string;
};

type AntonState = {
  running: boolean;
  taskFile?: string;
  startedAt?: string;
  currentIndex?: number;
  total?: number;
  completed?: number;
  skipped?: number;
  lastSummary?: string;
  stopRequested?: boolean;
  updatedAt?: string;
};

const ANTON_STATE_PATH = path.join(CONFIG_DIR, "anton.state.json");
const ANTON_LOCK_PATH = path.join(CONFIG_DIR, "anton.lock");

async function ensureStateDir() {
  await fs.mkdir(CONFIG_DIR, { recursive: true });
}

function parsePendingTasks(markdown: string): ParsedTask[] {
  const lines = markdown.split(/\r?\n/);
  const tasks: ParsedTask[] = [];
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i] ?? "";
    const m = line.match(/^(\s*)- \[ \] (.+)$/);
    if (!m) {
      continue;
    }
    tasks.push({ line: i + 1, indent: m[1] ?? "", text: (m[2] ?? "").trim() });
  }
  return tasks;
}

function markTaskDone(markdown: string, lineNo: number): string {
  const lines = markdown.split(/\r?\n/);
  const idx = lineNo - 1;
  if (idx < 0 || idx >= lines.length) {
    return markdown;
  }
  lines[idx] = (lines[idx] ?? "").replace(/^(\s*)- \[ \] /, "$1- [x] ");
  return `${lines.join("\n")}\n`;
}

async function readState(): Promise<AntonState> {
  try {
    return JSON.parse(await fs.readFile(ANTON_STATE_PATH, "utf8")) as AntonState;
  } catch {
    return { running: false };
  }
}

async function writeState(state: AntonState) {
  await ensureStateDir();
  await fs.writeFile(
    ANTON_STATE_PATH,
    `${JSON.stringify({ ...state, updatedAt: new Date().toISOString() }, null, 2)}\n`,
    "utf8",
  );
}

async function acquireLock(force = false) {
  await ensureStateDir();
  try {
    await fs.writeFile(
      ANTON_LOCK_PATH,
      JSON.stringify({ pid: process.pid, startedAt: new Date().toISOString() }),
      {
        encoding: "utf8",
        flag: "wx",
      },
    );
  } catch {
    if (!force) {
      throw new Error("Anton is already running (lock held)");
    }
    await fs.rm(ANTON_LOCK_PATH, { force: true });
    await fs.writeFile(
      ANTON_LOCK_PATH,
      JSON.stringify({ pid: process.pid, startedAt: new Date().toISOString(), force: true }),
      {
        encoding: "utf8",
        flag: "wx",
      },
    );
  }
}

async function releaseLock() {
  await fs.rm(ANTON_LOCK_PATH, { force: true });
}

export async function antonStatus(runtime: RuntimeEnv) {
  const s = await readState();
  if (!s.running) {
    runtime.log("Anton is idle.");
    if (s.lastSummary) {
      runtime.log(s.lastSummary);
    }
    return;
  }
  runtime.log(
    `Anton running: ${s.completed ?? 0}/${s.total ?? 0} complete` +
      (s.taskFile ? ` | file=${s.taskFile}` : "") +
      (typeof s.currentIndex === "number" ? ` | current=${s.currentIndex + 1}` : ""),
  );
}

export async function antonStop(runtime: RuntimeEnv) {
  const s = await readState();
  if (!s.running) {
    runtime.log("Anton is not running.");
    return;
  }
  await writeState({ ...s, stopRequested: true });
  runtime.log("Anton stop requested. It will stop after current task.");
}

async function shouldStop(): Promise<boolean> {
  const s = await readState();
  return Boolean(s.stopRequested);
}

function buildTaskPrompt(task: string): string {
  return [
    "You are executing one item from a managed checklist.",
    `Task: ${task}`,
    "Rules:",
    "1) Make the minimal code changes required for this task.",
    "2) Run targeted tests for your change.",
    "3) Return a concise completion summary.",
  ].join("\n");
}

export async function runAnton(args: {
  taskFile: string;
  runtime: RuntimeEnv;
  deps: CliDeps;
  agent?: string;
  to?: string;
  timeoutSec?: number;
  force?: boolean;
  dryRun?: boolean;
}) {
  const filePath = path.resolve(args.taskFile);
  const raw = await fs.readFile(filePath, "utf8");
  const pending = parsePendingTasks(raw);

  if (args.dryRun) {
    args.runtime.log(`Dry run: ${pending.length} pending task(s)`);
    for (const t of pending) {
      args.runtime.log(`- [ ] ${t.text}`);
    }
    return;
  }

  if (pending.length === 0) {
    args.runtime.log("No pending tasks.");
    return;
  }

  await acquireLock(Boolean(args.force));
  const startedAt = new Date().toISOString();
  await writeState({
    running: true,
    taskFile: filePath,
    startedAt,
    currentIndex: 0,
    total: pending.length,
    completed: 0,
    skipped: 0,
    stopRequested: false,
  });

  let completed = 0;
  let skipped = 0;

  try {
    for (let i = 0; i < pending.length; i++) {
      if (await shouldStop()) {
        args.runtime.log("Anton stop acknowledged.");
        break;
      }

      const task = pending[i];
      if (!task) {
        continue;
      }
      await writeState({
        running: true,
        taskFile: filePath,
        startedAt,
        currentIndex: i,
        total: pending.length,
        completed,
        skipped,
        stopRequested: false,
      });

      args.runtime.log(`\n[Anton] Task ${i + 1}/${pending.length}: ${task.text}`);

      try {
        const { loadConfig } = await import("../config/config.js");
        const cfg = loadConfig();
        const timeout =
          Number.isFinite(args.timeoutSec) && (args.timeoutSec ?? 0) > 0
            ? String(args.timeoutSec)
            : String(cfg.agents?.defaults?.timeoutSeconds ?? 1200);
        const { agentCliCommand } = await import("./agent-via-gateway.js");
        await agentCliCommand(
          {
            message: buildTaskPrompt(task.text),
            agent: args.agent,
            to: args.to,
            sessionId: `anton-${Date.now()}-${i + 1}`,
            timeout,
            json: false,
            deliver: false,
          },
          args.runtime,
          args.deps,
        );

        const latest = await fs.readFile(filePath, "utf8");
        const updated = markTaskDone(latest, task.line);
        await fs.writeFile(filePath, updated, "utf8");
        completed += 1;
      } catch (err) {
        skipped += 1;
        args.runtime.error(`[Anton] Task failed and was skipped: ${task.text}`);
        args.runtime.error(String(err));
      }
    }

    const summary = `Anton finished: completed=${completed}, skipped=${skipped}, total=${pending.length}`;
    await writeState({
      running: false,
      taskFile: filePath,
      startedAt,
      total: pending.length,
      completed,
      skipped,
      lastSummary: summary,
      stopRequested: false,
    });
    args.runtime.log(`\n${summary}`);
  } finally {
    await releaseLock();
  }
}
