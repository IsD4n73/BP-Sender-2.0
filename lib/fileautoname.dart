import 'dart:io';

void main() async {
  var baseFile = File("/Users/dante.davidde/Desktop/filess/1.xlsx");
  await renameFile(baseFile);
}

Future<void> renameFile(File baseFile) async {
  if (File(baseFile.path.replaceAll("1", "ts")).existsSync()) {
    int fileGiaEsistenti = 0;
    while (true) {
      File nextFilePath =
          File("${baseFile.parent.path}/ts (${fileGiaEsistenti + 1}).xlsx");

      if (!await nextFilePath.exists()) {
        await baseFile.rename(nextFilePath.path);
        return;
      } else {
        fileGiaEsistenti++;
      }
    }
  } else {
    await baseFile.rename(
      baseFile.path.replaceAll("1", "ts"),
    );
  }
}
