package ai.idlehands.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class IdleHandsProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", IdleHandsCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", IdleHandsCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", IdleHandsCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", IdleHandsCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", IdleHandsCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", IdleHandsCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", IdleHandsCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", IdleHandsCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", IdleHandsCapability.Canvas.rawValue)
    assertEquals("camera", IdleHandsCapability.Camera.rawValue)
    assertEquals("screen", IdleHandsCapability.Screen.rawValue)
    assertEquals("voiceWake", IdleHandsCapability.VoiceWake.rawValue)
    assertEquals("location", IdleHandsCapability.Location.rawValue)
    assertEquals("sms", IdleHandsCapability.Sms.rawValue)
    assertEquals("device", IdleHandsCapability.Device.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", IdleHandsCameraCommand.List.rawValue)
    assertEquals("camera.snap", IdleHandsCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", IdleHandsCameraCommand.Clip.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", IdleHandsScreenCommand.Record.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", IdleHandsNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", IdleHandsNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", IdleHandsDeviceCommand.Status.rawValue)
    assertEquals("device.info", IdleHandsDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", IdleHandsDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", IdleHandsDeviceCommand.Health.rawValue)
  }
}
