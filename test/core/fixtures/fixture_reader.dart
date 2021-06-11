import 'dart:io';

String fixture(String jsonFile) =>
    File('test/core/fixtures/$jsonFile').readAsStringSync();
