package ai.idlehands.android.ui

import androidx.compose.runtime.Composable
import ai.idlehands.android.MainViewModel
import ai.idlehands.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
