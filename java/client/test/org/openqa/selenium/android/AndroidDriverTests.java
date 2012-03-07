/*
Copyright 2010 WebDriver committers
Copyright 2010 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

package org.openqa.selenium.android;

import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.openqa.selenium.StandardSeleniumTests;
import org.openqa.selenium.android.environment.AndroidTestEnvironment;
import org.openqa.selenium.environment.GlobalTestEnvironment;
import org.openqa.selenium.environment.TestEnvironment;

/**
 * Unit tests suite for Android driver.
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
    StandardSeleniumTests.class
})
public class AndroidDriverTests {

  @BeforeClass
  public static void startEnvironment() {
    TestEnvironment env = GlobalTestEnvironment.get();
    if (env != null) {
      env.stop();
    }
    GlobalTestEnvironment.set(new AndroidTestEnvironment());
  }
}