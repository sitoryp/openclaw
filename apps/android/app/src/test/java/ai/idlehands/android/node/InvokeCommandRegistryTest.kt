package ai.idlehands.android.node

import ai.idlehands.android.protocol.IdleHandsCameraCommand
import ai.idlehands.android.protocol.IdleHandsDeviceCommand
import ai.idlehands.android.protocol.IdleHandsLocationCommand
import ai.idlehands.android.protocol.IdleHandsNotificationsCommand
import ai.idlehands.android.protocol.IdleHandsSmsCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        cameraEnabled = false,
        locationEnabled = false,
        smsAvailable = false,
        debugBuild = false,
      )

    assertFalse(commands.contains(IdleHandsCameraCommand.Snap.rawValue))
    assertFalse(commands.contains(IdleHandsCameraCommand.Clip.rawValue))
    assertFalse(commands.contains(IdleHandsCameraCommand.List.rawValue))
    assertFalse(commands.contains(IdleHandsLocationCommand.Get.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Status.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Info.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Permissions.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Health.rawValue))
    assertTrue(commands.contains(IdleHandsNotificationsCommand.List.rawValue))
    assertTrue(commands.contains(IdleHandsNotificationsCommand.Actions.rawValue))
    assertFalse(commands.contains(IdleHandsSmsCommand.Send.rawValue))
    assertFalse(commands.contains("debug.logs"))
    assertFalse(commands.contains("debug.ed25519"))
    assertTrue(commands.contains("app.update"))
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        cameraEnabled = true,
        locationEnabled = true,
        smsAvailable = true,
        debugBuild = true,
      )

    assertTrue(commands.contains(IdleHandsCameraCommand.Snap.rawValue))
    assertTrue(commands.contains(IdleHandsCameraCommand.Clip.rawValue))
    assertTrue(commands.contains(IdleHandsCameraCommand.List.rawValue))
    assertTrue(commands.contains(IdleHandsLocationCommand.Get.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Status.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Info.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Permissions.rawValue))
    assertTrue(commands.contains(IdleHandsDeviceCommand.Health.rawValue))
    assertTrue(commands.contains(IdleHandsNotificationsCommand.List.rawValue))
    assertTrue(commands.contains(IdleHandsNotificationsCommand.Actions.rawValue))
    assertTrue(commands.contains(IdleHandsSmsCommand.Send.rawValue))
    assertTrue(commands.contains("debug.logs"))
    assertTrue(commands.contains("debug.ed25519"))
    assertTrue(commands.contains("app.update"))
  }
}
