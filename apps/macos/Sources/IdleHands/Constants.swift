import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-idlehands writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.idlehands.mac"
let gatewayLaunchdLabel = "ai.idlehands.gateway"
let onboardingVersionKey = "idlehands.onboardingVersion"
let onboardingSeenKey = "idlehands.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "idlehands.pauseEnabled"
let iconAnimationsEnabledKey = "idlehands.iconAnimationsEnabled"
let swabbleEnabledKey = "idlehands.swabbleEnabled"
let swabbleTriggersKey = "idlehands.swabbleTriggers"
let voiceWakeTriggerChimeKey = "idlehands.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "idlehands.voiceWakeSendChime"
let showDockIconKey = "idlehands.showDockIcon"
let defaultVoiceWakeTriggers = ["idlehands"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "idlehands.voiceWakeMicID"
let voiceWakeMicNameKey = "idlehands.voiceWakeMicName"
let voiceWakeLocaleKey = "idlehands.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "idlehands.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "idlehands.voicePushToTalkEnabled"
let talkEnabledKey = "idlehands.talkEnabled"
let iconOverrideKey = "idlehands.iconOverride"
let connectionModeKey = "idlehands.connectionMode"
let remoteTargetKey = "idlehands.remoteTarget"
let remoteIdentityKey = "idlehands.remoteIdentity"
let remoteProjectRootKey = "idlehands.remoteProjectRoot"
let remoteCliPathKey = "idlehands.remoteCliPath"
let canvasEnabledKey = "idlehands.canvasEnabled"
let cameraEnabledKey = "idlehands.cameraEnabled"
let systemRunPolicyKey = "idlehands.systemRunPolicy"
let systemRunAllowlistKey = "idlehands.systemRunAllowlist"
let systemRunEnabledKey = "idlehands.systemRunEnabled"
let locationModeKey = "idlehands.locationMode"
let locationPreciseKey = "idlehands.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "idlehands.peekabooBridgeEnabled"
let deepLinkKeyKey = "idlehands.deepLinkKey"
let modelCatalogPathKey = "idlehands.modelCatalogPath"
let modelCatalogReloadKey = "idlehands.modelCatalogReload"
let cliInstallPromptedVersionKey = "idlehands.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "idlehands.heartbeatsEnabled"
let debugPaneEnabledKey = "idlehands.debugPaneEnabled"
let debugFileLogEnabledKey = "idlehands.debug.fileLogEnabled"
let appLogLevelKey = "idlehands.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
