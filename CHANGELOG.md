# CHANGELOG
## [1.3.6] - 2023-04-03

* Fixed issue where `delete` call was not awaited leading to a possible inconsistency when 
  deleting and then reading a ref immediately afterwards

## [1.3.5] - 2023-02-26

* Fixed issue #25 Windows path separator
* Fixed issue #24 race condition when deleting a collection 

## [1.3.4] - 2022-12-12

* Fixed bug (thank charleybin)

## [1.3.2] - 2022-12-12

* Fixed bug (thank charleybin)

## [1.3.1] - 2022-12-03

* Added UML diagram
* Fixed some bug

## [1.3.0] - 2022-12-01

* Added delete collection
* Fixed some bug

## [1.2.3] - 2022-03-13

* Update example
* Fixed some bug

## [1.2.2] - 2022-03-10

* Fix async io._getAll

## [1.2.1] - 2021-11-08

* Use rethrow over throw error, add unlockSync()
* Fix path getting for document reference

## [1.2.0] - 2021-05-04

* Get doc nullable by default

## [1.1.10] - 2021-05-04

* Fixed: get() doc on the web

## [1.1.9] - 2021-05-04

* Fixed: get() doc on the web
* Updated example on the web

## [1.1.8] - 2021-04-21

* Fixed: delete doc on the web
* Updated: Example

## [1.1.7] - 2021-04-13

* Using platform specific path seperator

## [1.1.6] - 2021-04-11

* Fixed: Stream has already been listened to (web)

## [1.1.5] - 2021-04-10

* Fixed: Stream has already been listened to

## [1.1.4] - 2021-04-07

* Fixed: issues with openSync and closeSync

## [1.1.3] - 2021-04-01

* Fixed: Dirctory listing failed
* Fixed: OS Error: Too many open files, errno = 24

## [1.1.2] - 2021-03-30

* Fixed: Null check operator used on a null value

## [1.1.1] - 2021-03-30

* Fixed: An async operation is currently pending

## [1.1.0+4] - 2021-03-28

* Updated README

## [1.1.0+3] - 2021-03-26

* Updated README

## [1.1.0+2] - 2021-03-26

* Updated README

## [1.1.0+1] - 2021-03-26

* Updated API documentation

## [1.1.0] - 2021-03-19

* Fetch the documents for the collection
* Added query where but not implemented (need contribution)

## [1.0.0] - 2021-03-15

* Worked on the web

## [0.5.0+1] - 2021-03-15

* Providing documentation
* Fixed compatibility issues
* Removed unused imports

## [0.5.0] - 2021-03-14

* Worked on mobile

## [0.0.1] - 2021-03-14

* Initial release.
