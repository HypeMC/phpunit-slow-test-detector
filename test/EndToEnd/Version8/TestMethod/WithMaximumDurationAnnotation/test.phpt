--TEST--
With test methods with @maximumDuration annotations
--FILE--
<?php

declare(strict_types=1);

use PHPUnit\TextUI;

$_SERVER['argv'][] = '--configuration=test/EndToEnd/Version8/TestMethod/WithMaximumDurationAnnotation/phpunit.xml';

require_once __DIR__ . '/../../../../../vendor/autoload.php';

PHPUnit\TextUI\Command::main();
--EXPECTF--
PHPUnit %s

Runtime: %s
Configuration: %s/EndToEnd/Version8/TestMethod/WithMaximumDurationAnnotation/phpunit.xml
Random %seed:   %s

....                                                                4 / 4 (100%)

Detected 2 tests that took longer than expected.

1. 0.3%s (0.200) Ergebnis\PHPUnit\SlowTestDetector\Test\EndToEnd\Version8\TestMethod\WithMaximumDurationAnnotation\SleeperTest::testSleeperSleepsLongerThanMaximumDurationFromAnnotationWhenTestMethodHasValidMaximumDurationAnnotation
2. 0.2%s (0.100) Ergebnis\PHPUnit\SlowTestDetector\Test\EndToEnd\Version8\TestMethod\WithMaximumDurationAnnotation\SleeperTest::testSleeperSleepsLongerThanMaximumDurationFromXmlConfigurationWhenTestMethodHasInvalidMaximumDurationAnnotation

Time: %s, Memory: %s

OK (4 tests, 4 assertions)
