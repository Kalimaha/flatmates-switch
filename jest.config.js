{
  "testEnvironment": "jsdom",
  "setupFiles": [
    "./lib/switch_web/client/js/utilities/shims.util.js",
    "./lib/switch_web/client/js/utilities/setupTests.util.js"
  ],
  "roots": [
    "./"
  ],
  "collectCoverageFrom": [
    "**/*.{js,jsx}",
    "!**/*.{config,util}.*",
    "!**/coverage/**",
    "!**/node_modules/**",
    "!**/vendor/**",
    "!**/build/**",
    "!**/public/**"
  ],
  "moduleNameMapper": {
    "\\.(css|scss|sass)$": "identity-obj-proxy"
  },
  "moduleFileExtensions": [
    "js",
    "jsx"
  ],
  "moduleDirectories": [
    "node_modules",
    "src"
  ],
  "testPathIgnorePatterns": [
    "/node_modules/",
    "/site-packages/"
  ]
}