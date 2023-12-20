--TEST--
With a test case that has setUpBeforeClass(), tearDownAfterClass(), setUp(), assertPreConditions(), assertPostConditions(), tearDown() methods and test methods with @runInSeparateProcess annotation
--FILE--
<?php

declare(strict_types=1);

use PHPUnit\TextUI;

$_SERVER['argv'][] = '--configuration=test/EndToEnd/Version09/TestMethod/WithRunInSeparateProcessAnnotation/phpunit.xml';
$_SERVER['argv'][] = '--random-order-seed=1234567890';

/**
 * @see https://github.com/sebastianbergmann/phpunit/blob/9.0.0/src/Framework/TestCase.php#L706-L708
 */
define('PHPUNIT_COMPOSER_INSTALL', __DIR__ . '/../../../../../vendor/autoload.php');

require_once PHPUNIT_COMPOSER_INSTALL;

PHPUnit\TextUI\Command::main();
--EXPECTF--
PHPUnit %s

Runtime: %s
Configuration: %s/EndToEnd/Version09/TestMethod/WithRunInSeparateProcessAnnotation/phpunit.xml
Random %seed:   %s

....                                                                4 / 4 (100%)

Detected 4 tests that took longer than expected.

1. 0.9%s (0.100) Ergebnis\PHPUnit\SlowTestDetector\Test\EndToEnd\Version09\TestMethod\WithRunInSeparateProcessAnnotation\SleeperTest::testSleeperSleepsLongerThanMaximumDurationFromXmlConfigurationWhenMethodHasRunInSeparateProcessAnnotation
2. 0.6%s (0.100) Ergebnis\PHPUnit\SlowTestDetector\Test\EndToEnd\Version09\TestMethod\WithRunInSeparateProcessAnnotation\SleeperTest::testSleeperSleepsShorterThanMaximumDurationFromXmlConfigurationWhenMethodHasRunInSeparateProcessAnnotation
3. 0.6%s (0.100) Ergebnis\PHPUnit\SlowTestDetector\Test\EndToEnd\Version09\TestMethod\WithRunInSeparateProcessAnnotation\SleeperTest::testSleeperSleepsLongerThanMaximumDurationFromXmlConfiguration
4. 0.4%s (0.100) Ergebnis\PHPUnit\SlowTestDetector\Test\EndToEnd\Version09\TestMethod\WithRunInSeparateProcessAnnotation\SleeperTest::testSleeperSleepsShorterThanMaximumDurationFromXmlConfiguration

Time: %s, Memory: %s

OK (4 tests, 4 assertions)