# Change log

## Version 1.0.0 (Under Developement)
Released on 2015-11-13.

- [UPDATE] Rename `supportedTokensInSplitflap:` method to `tokensInSplitflap:`
- [ADD] `setText:animated:completionBlock:` method to know when an animation finished 

## [Version 0.2.0](https://github.com/yannickl/Splitflap/releases/tag/0.2.0)
Released on 2015-11-12.

- [FIX] Parse characters and words
- [ADD] `FlapViewBuilder` to make flap configuration easier
- [ADD] `splitflap:builderForFlapAtIndex:` method to customize the each flap individually:
  - `backgroundColor`, `cornerRadius`, `font`, `textAlignment`, `textColor`, `lineColor`

## [Version 0.1.0](https://github.com/yannickl/Splitflap/releases/tag/0.1.0)
Released on 2015-11-11.

- `flapSpacing` property to configure the spacing between flaps
- `supportedTokensInSplitflap:` method to define the "characters" used by flaps
- `numberOfFlapsInSplitflap:` to set the number of flaps
- `splitflap(splitflap:rotationDurationForFlapAtIndex:` method to change the rotation duration of each flaps
- Cocoapods support
- Carthage support
