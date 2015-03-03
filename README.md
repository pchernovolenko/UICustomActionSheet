#UICustomActionSheet

Fully customizable `UIActionSheet` replacement. Compatible with iOS 7 and 8.


This сustom ActionSheet can also emphasize the element the menu is related to, by blurring the background of the presenting view. The element itself remains clear.


![Screen1](https://cloud.githubusercontent.com/assets/7644394/6421975/7da04fac-bedc-11e4-9d87-59b8696a664e.gif)
![Screen2](https://cloud.githubusercontent.com/assets/7644394/6421813/160a4e2a-bedb-11e4-803f-a474e64f6f6a.gif)


##How to use


Simply init UICustomActionSheet object in the same way you do with UIActionSheet:

    UICustomActionSheet *actionSheet = [[UICustomActionSheet alloc] initWithTitle:@"Hello World" delegate:self buttonTitles:@[@"Bottom button",@"Top button"]];

To present UICustomActionSheet in the view, you may use the same method as in UIActionSheet:

    [actionSheet showInView:self.view];

For handling UICustomActionSheet's events, presenting controller must implement `UICustomActionSheetDelegate`'s method:

    -(void)customActionSheet:(UICustomActionSheet *)customActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        NSLog(@"%d",buttonIndex);
    }

Feel free to set `nil` for `title` if you don't want it to be shown in your ActionSheet.  Do any customization stuff you need:

##Customization using methods

`-(void)setButtonColors:(NSArray *)colors` - method to set an array of buttons colors. If `colors` array contains less elements than buttons number in UICustomActionSheet, only first `[colors count]` buttons will be colored with given in array colors, all next buttons will be colored with `tintColor` (default `grayColor`)


`-(void)setTitle:(NSString *)title andSubtitle:(NSString *)subtitle` - set title and subtitle to UICustomActionSheet. Both values are `nil` as default. 


##Customization using properties


###Colors


`tintColor` - standard color for UICustomActionSheet's buttons


`backgroundColor` - color for panel background. Set it with `[UIColor clearColor]` value to make it transparent


`blurTintColor` - translucent color for tinting UICustomActionSheet's background in case `blurredBackground = YES`. The default value is `[UIColor colorWithWhite:0.1 alpha:0.4]`. 


`titleColor` - title color for UICustomActionSheet. The default value is `whiteColor`


`subtitleColor` - subtitle color for UICustomActionSheet. The default value is `lightGrayColor`


`buttonsTextColor` - button's text color for normal state . The default value is `whiteColor`


###Title and subtitle font size 


`subtitle` - subtitle text. It doesn't effect if it's `nil`


`subtitleFontSize` - `float` value for subtitle text font size. The default value is `14.0`


`title` - main title text. It doesn't effect if it's `nil`


`titleFontSize` - `float` value for title text font size. The default value is `22.0`

###Background customization

`blurredBackground` - `bool` value. Set `NO` if you don't want to blur UICustomActionSheet presenter view. The default value is `YES`


`claerArea` - `CGRect` value. Receives rect, which won't be blurred in case `blurredBackground = YES`


## License

The MIT License (MIT)


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
