# testswift

* It is a command line tool that checks whether you have unit test code of swift function or not.
* Testswift  follows the  SFTDD Menifesto.

```
$ ./testswift
testswift - v0.9.0

usage: testswift --check [target root path]
   or: testswift --testcode [source path]
   or: testswift -h  or  --help               Print Help (this message)
```

## SFTDD Menifesto (System Forced Test Deriven Development)

* The system decide the unit tests you need.
* If you are satisfied with the unit tests required by system, you can trust the code.

## testswift Rules

### common rules
* Unit test file for a single swift file must exist.
* All func, init which are implemented in the swift file should have unit test code.


### unit test file naming

* A folder path for the unit test code has "Tests" as a postfix.
 * ex) /Users/ryan/workspace/app-ios/appTests
* A file name for the unit test code has "Tests" as a postfix.
 * ex) /Users/ryan/workspace/app-ios/appTests/AppDelegateTests.swift

### unit test function naming
* The function name for the test has "Tests" as a prefix of its original name.
 * ex) The test code of  func saveContext ()  is  func testSaveContext()
* If there is arguments on the original name, use _ as a separator to list argument name.
 * ex) func testApplication_application_openURL_sourceApplication_annotation()
* If == is used for function name for test, it is replaced by EE
* If < is used for function name for test, it is replaced by LT

## Example

### To check

```
$ ./testswift --check /Users/ryan/workspace/project-ios/project
/Users/ryan/workspace/project-ios/appTests/extension/UIViewController+ExtensionTests.swift is not exist.
```

### To generate test template code.

```
$ ./testswift --testcode /Users/ryan/workspace/app-ios/project/extension/UIViewController+Extension.swift
func testAppInfo() {
XCTAssert(true, "It does not need to be tested.")
}
```

## License

testswift use GNU GPL v3. Please refer to the LICENSE file for detailed information.
