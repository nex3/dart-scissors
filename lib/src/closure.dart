// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
library scissors;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:scissors/src/io_utils.dart';

Future<String> simpleClosureCompile(
    String closureCompilerJarPath, String content) async {
  var p = await Process.start(
      'java',
      [
        '-jar',
        closureCompilerJarPath,
        '--language_in=ES5',
        '--language_out=ES5',
        '-O',
        'SIMPLE'
      ],
      mode: ProcessStartMode.DETACHED_WITH_STDIO);

  p.stdin.writeln(content);
  p.stdin.close();

  var out = readAll(p.stdout);
  var err = readAll(p.stderr);

  if ((await p.exitCode ?? 0) != 0) {
    var errStr = new Utf8Decoder().convert(await err);
    throw new ArgumentError(
        'Failed to run Closure Compiler (exit code = ${await p.exitCode}):\n$errStr');
  }
  return new Utf8Decoder().convert(await out);
}
