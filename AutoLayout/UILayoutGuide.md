![[UILayoutGuide.png| 800]]

## SafeAreaLayoutGuide
It appears at ***top*** and the ***bottom*** of the controllers. Apple introduce this to make it for us to know which areas are safe to layout controls in, and those areas best avoided.  

## LayoutMarginsGuide  
These are rectangular areas view can create to define margins and spacing. For example, apple defined default layout margins and all of it views within it's ViewController, that developers can pin controls to, when for example displaying text.
> Developers can define their own layout margins too, and this can be handy for spacing.

## ReadableContentGuide
It is a dynamicaly calculated are that tries to preserve content for reading based on orientation and font size. 
>If `leadingAnchor` and `trailingAnchor` is being used with `ReadableContentGuide` iOS will automatically display the current reading direction of the text based on the language in the `Locale`.  

# See Also
1. [How to use UILayoutGuide as equal spacer between views](LayoutMargin%20as%20spacer%20guide.md)
2. [How to use LayoutMarginsGuide](Layout%20Margin%20Guide%20Example.md)
3. 
4. 