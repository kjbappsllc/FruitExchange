// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
@import SpriteKit;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;

SWIFT_CLASS("_TtC14Fruit_Exchange11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCoder;
@class CircleMenuButton;
@class UIView;

/**
  A Button object with pop ups buttons
*/
SWIFT_CLASS("_TtC14Fruit_Exchange10CircleMenu")
@interface CircleMenu : UIButton
/**
  Buttons count
*/
@property (nonatomic) NSInteger buttonsCount;
/**
  Circle animation duration
*/
@property (nonatomic) double duration;
/**
  Distance between center button and buttons
*/
@property (nonatomic) float distance;
/**
  Delay between show buttons
*/
@property (nonatomic) double showDelay;
/**
  The object that acts as the delegate of the circle menu.
*/
@property (nonatomic, weak) IBOutlet id _Nullable delegate;
@property (nonatomic, copy) NSArray<UIButton *> * _Nullable buttons;
@property (nonatomic, weak) UIView * _Nullable platform;
/**
  Initializes and returns a circle menu object.
  \param frame A rectangle specifying the initial location and size of the circle menu in its superview’s coordinates.

  \param normalIcon The image to use for the specified normal state.

  \param selectedIcon The image to use for the specified selected state.

  \param buttonsCount The number of buttons.

  \param duration The duration, in seconds, of the animation.

  \param distance Distance between center button and sub buttons.


  returns:
  A newly created circle menu.
*/
- (nonnull instancetype)initWithFrame:(CGRect)frame normalIcon:(NSString * _Nullable)normalIcon selectedIcon:(NSString * _Nullable)selectedIcon buttonsCount:(NSInteger)buttonsCount duration:(double)duration distance:(float)distance OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/**
  Hide button
  \param duration The duration, in seconds, of the animation.

  \param hideDelay The time to delay, in seconds.

*/
- (void)hideButtons:(double)duration hideDelay:(double)hideDelay;
/**
  Check is sub buttons showed
*/
- (BOOL)buttonsIsShown;
- (void)onTap;
- (void)buttonHandler:(CircleMenuButton * _Nonnull)sender;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC14Fruit_Exchange16CircleMenuButton")
@interface CircleMenuButton : UIButton
@property (nonatomic, weak) UIView * _Nullable container;
- (nonnull instancetype)initWithSize:(CGSize)size platform:(UIView * _Nonnull)platform distance:(float)distance angle:(float)angle OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)rotatedZWithAngle:(float)angle animated:(BOOL)animated duration:(double)duration delay:(double)delay;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


@interface CircleMenuButton (SWIFT_EXTENSION(Fruit_Exchange))
- (void)showAnimationWithDistance:(float)distance duration:(double)duration delay:(double)delay;
- (void)hideAnimationWithDistance:(float)distance duration:(double)duration delay:(double)delay;
- (void)changeDistance:(CGFloat)distance animated:(BOOL)animated duration:(double)duration delay:(double)delay;
- (void)rotationAnimation:(float)angle duration:(double)duration;
@end


/**
  CircleMenuDelegate
*/
SWIFT_PROTOCOL("_TtP14Fruit_Exchange18CircleMenuDelegate_")
@protocol CircleMenuDelegate
@optional
/**
  Tells the delegate the circle menu is about to draw a button for a particular index.
  \param circleMenu The circle menu object informing the delegate of this impending event.

  \param button A circle menu button object that circle menu is going to use when drawing the row. Don’t change button.tag

  \param atIndex An button index.

*/
- (void)circleMenu:(CircleMenu * _Nonnull)circleMenu willDisplay:(UIButton * _Nonnull)button atIndex:(NSInteger)atIndex;
/**
  Tells the delegate that a specified index is about to be selected.
  \param circleMenu A circle menu object informing the delegate about the impending selection.

  \param button A selected circle menu button. Don’t change button.tag

  \param atIndex Selected button index

*/
- (void)circleMenu:(CircleMenu * _Nonnull)circleMenu buttonWillSelected:(UIButton * _Nonnull)button atIndex:(NSInteger)atIndex;
/**
  Tells the delegate that the specified index is now selected.
  \param circleMenu A circle menu object informing the delegate about the new index selection.

  \param button A selected circle menu button. Don’t change button.tag

  \param atIndex Selected button index

*/
- (void)circleMenu:(CircleMenu * _Nonnull)circleMenu buttonDidSelected:(UIButton * _Nonnull)button atIndex:(NSInteger)atIndex;
/**
  Tells the delegate that the menu was collapsed - the cancel action.
  \param circleMenu A circle menu object informing the delegate about the new index selection.

*/
- (void)menuCollapsed:(CircleMenu * _Nonnull)circleMenu;
@end

@class CAShapeLayer;
@class UIColor;

SWIFT_CLASS("_TtC14Fruit_Exchange16CircleMenuLoader")
@interface CircleMenuLoader : UIView
@property (nonatomic, strong) CAShapeLayer * _Nullable circle;
- (nonnull instancetype)initWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth platform:(UIView * _Nonnull)platform color:(UIColor * _Nullable)color OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)createRoundView:(CGRect)rect color:(UIColor * _Nullable)color;
- (void)fillAnimation:(double)duration startAngle:(float)startAngle completion:(void (^ _Nonnull)(void))completion;
- (void)hideAnimation:(CGFloat)duration delay:(double)delay completion:(void (^ _Nonnull)(void))completion;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end

@class SKView;
@class UITouch;
@class UIEvent;

SWIFT_CLASS("_TtC14Fruit_Exchange9GameScene")
@interface GameScene : SKScene
- (void)didMoveToView:(SKView * _Nonnull)view;
- (void)updateMovesLabel:(NSInteger)number;
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row;
- (void)addTiles;
- (void)hideSelectionIndicator;
- (void)animateGameOver:(void (^ _Nonnull)(void))completion;
- (void)animateBeginGame;
- (void)removeAllFruitSprites;
- (void)touchesBegan:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)touchesMoved:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)touchesEnded:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)touchesCancelled:(NSSet<UITouch *> * _Nonnull)touches withEvent:(UIEvent * _Nullable)event;
- (void)trySwapHorizontal:(NSInteger)horzDelta vertical:(NSInteger)vertDelta;
- (void)update:(NSTimeInterval)currentTime;
- (nonnull instancetype)initWithSize:(CGSize)size OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSBundle;

SWIFT_CLASS("_TtC14Fruit_Exchange18GameViewController")
@interface GameViewController : UIViewController
@property (nonatomic, strong) GameScene * _Null_unspecified scene;
@property (nonatomic) NSInteger movesLeft;
@property (nonatomic, readonly) BOOL shouldAutorotate;
@property (nonatomic, readonly) UIInterfaceOrientationMask supportedInterfaceOrientations;
- (void)didReceiveMemoryWarning;
@property (nonatomic, readonly) BOOL prefersStatusBarHidden;
- (void)viewDidLoad;
- (void)setupLevel:(NSInteger)levelNum;
- (void)beginGame;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC14Fruit_Exchange18MainViewController")
@interface MainViewController : UIViewController <CircleMenuDelegate>
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)circleMenu:(CircleMenu * _Nonnull)circleMenu willDisplay:(UIButton * _Nonnull)button atIndex:(NSInteger)atIndex;
- (void)circleMenu:(CircleMenu * _Nonnull)circleMenu buttonWillSelected:(UIButton * _Nonnull)button atIndex:(NSInteger)atIndex;
- (void)circleMenu:(CircleMenu * _Nonnull)circleMenu buttonDidSelected:(UIButton * _Nonnull)button atIndex:(NSInteger)atIndex;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIView (SWIFT_EXTENSION(Fruit_Exchange))
@property (nonatomic, readonly) float angleZ;
@end

#pragma clang diagnostic pop