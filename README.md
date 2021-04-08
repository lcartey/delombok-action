# delombok-action

This actions runs "delombok" on the source code of the repository in place. Where possibly, the delomboked code removes line breaks to retain the locations of the original source code.

The action will do nothing on source code which does not include at least one Project Lombok import.
