/**
  Project: Bophex-Flim
  File: percussion/hihat--gui.scd
  Author: Leonard M Reidy
  Source:
  Docs: [ http://supercollider.sourceforge.net/wiki/index.php/User_FAQ ]
  Description: This file isolates the hihats of the bophex-flim project for further analysis. It
  contains:

    - hihats GUI control in a single widget
    - all melody/harmony GUI elements removed from widget
    - all other percussion elements removed from widget
    - a subset of the GUI controls for FX (reverb and combs)
    - tempo control
    - further improvments to comments

  General Notes

  To Execute: Ctrl + Enter (Cmd + Enter on MacOS)
  To hush: Ctrl + . (Cmd + . on MacOS)

*/

(

  /* -------------------------------------------------------------------------------------- */
  /* [INITIALIZATION] Initialize variables for UI components, colors, and dimensions        */
  /* ---------------------------------------------------------------------------------------*/

  // Declare and initialize variable to represent GUI
  q = q ? ();

  // Declare and initialize properties for the GUI object to represent UI components
  q.button = ();
  q.slider = ();
  q.window = ();
  q.color = ();
  q.text = ();

  // Configure Colors
  q.color.green = Color.fromHexString("#00cc00");
  q.color.red = Color.fromHexString("#ff0000");
  q.color.black = Color.fromHexString("#000000");
  q.color.white = Color.fromHexString("#FFFFFF");

  q.color.lightorange = Color.fromHexString("#ffb27f");
  q.color.mediumorange = Color.fromHexString("#ff8432");
  q.color.orange = Color.fromHexString("#FF6600");

  q.color.lightblue = Color.fromHexString("#7fccff");
  q.color.mediumblue = Color.fromHexString("#32adff");
  q.color.blue = Color.fromHexString("#0099ff");

  q.color.lightgray = Color.fromHexString("#928c8c");
  q.color.mediumgray = Color.fromHexString("#c7bdbd");
  q.color.gray = Color.fromHexString("#878484");

  // Configure Window properties
  q.window.bounds = Rect(left: 400, top: 100, width: 300, height: 300);
  q.window.title = "Bophex Flim: Percussion";

  // Configure other element dimensions

  // Specify a minimum width for slider to prevent it rendering in vertical orientation
  q.slider.width = 50;

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define text label for transport buttons                                    */
  /* ---------------------------------------------------------------------------------------*/

  /*
    TEXT LABELS

    StaticText is a view class for displaying non-editable text labels. Here, we create an
    instance of the StaticText class and set some of its properties at the same time by
    chaining the string and stringColor instance methods. The string method sets the value
    of the text label, in this case "Transport". The stringColor sets the color of the text
    label, in this case the gray color defined earlier and referred to by q.color.gray. Text
    labels are used routinely in the project in this way.
  */
  q.text.transport = StaticText()
    // Label Text
	.string_("Transport")
    // Label Color
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define START_ALL/STOP_ALL transport button                                 */
  /* ---------------------------------------------------------------------------------------*/


  /*
    BUTTONS

    q.button.start stores a reference to a newly instantiated Button object. Button is a class
    for instantiating multi-state buttons. Objects of this class have states and perform
    actions (whenever the button is released).

    Button States
    The states instance method of a button object sets an array of arrays which map labels and
    colors which define the visible states of the button and the text displayed in the button.

    Button Action/s
    Buttons have a method called action that provides an object to set as default action, usually
    a Function or a FunctionList. When evaluated, it will be passed the view as an argument. Below,
    the view is represented by the parameter |v|, and the code checks against the value of v to
    determine whether to execute the play branch of execution, or the stop branch of execution.

    Consider the play branch of execution:

    {
      Pdef(\hihat).play;
      q.button.hihat.visible_(true);
      q.button.hihat.valueAction_(0);
    }

    This is an anonymous function which consists of three statements:
      (i) one to execute the play method on the hihat Pdef (defined in hihat--synths.scd);
      (ii) one to make the start/stop hihat button visible;
      (iii) one to execute the hihat button's 0th execution branch.

    Compare the stop branch of execution:

	{
	  Pdef(\hihat).stop;
	  q.button.hihat.visible_(false);
	  q.button.hihat.valueAction_(1);
 	}

    This is also an anonymous function which consists of three statements:
      (i) one to execute the stop method on the hihat Pdef (defined in hihat--synths.scd);
      (ii) one to make the start/stop hihat button invisible;
      (iii) one to execute the hihat button's 1th execution branch.

    Note that practically every button in the GUI is composed in the same way:
    (i) instantiate the button with a call to .new();
    (ii) set the states
    (iii) set the actions

    The general form of statements for instantiating buttons looks like this:

        Button.new().states_(STATES).action_(ACTIONS);

    where STATES is an array of arrays representing the states of the button,
    and ACTIONS is an object that represents the actions the button can perform.

    It is also worth remarking here that the form demonstrates that this is a complete, single statement, which
    uses a common Object Oriented programming technique, called method chaining, to define a button.

  */
  q.button.start = Button.new()
	.states_([
		[ "Start all", 	q.color.white, q.color.green ],
		[ "Stop all", 	q.color.white, q.color.red ]
	])
	.action_{|v|
		(v.value == 1).if(
			{
			    Pdef(\hihat).play;
			    q.button.hihat.visible_(true);
				q.button.hihat.valueAction_(0);

			},
			{
			    Pdef(\hihat).stop;
			    q.button.hihat.visible_(false);
				q.button.hihat.valueAction_(1);
 			}
		)
	};


  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define text label for transport tempo slider control                       */
  /* ---------------------------------------------------------------------------------------*/
  q.text.tempoString = StaticText()
	.string_("Tempo")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define number box for transport tempo slider control                       */
  /* ---------------------------------------------------------------------------------------*/

  /*
    A NumberBox is a view for displaying numerical values which permits the user to edit it,
    either by typing in the value or using keyboard/mouse. The value method sets the value
    of the NumberBox instance.
  */
  q.text.tempo = NumberBox().value_(75);

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define transport tempo slider control                                      */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.tempo = Slider.new(w,Rect(width: q.slider.width))
	.action_{|v|
		TempoClock.default.tempo_(v.value + 0.2 * 2);
		q.text.tempo.value_( (v.value + 0.2 * 60 * 2).round )
	}
	.value_(0.425);

  /* -------------------------------------------------------------------------------------- */
  /* [VOICES] Define text label for voice buttons                                           */
  /* ---------------------------------------------------------------------------------------*/
  q.text.voices = StaticText()
	.string_("Voices: HiHat")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [VOICES] Define HIHAT voice button                                                      */
  /* ---------------------------------------------------------------------------------------*/
  q.button.hihat = Button.new()
	.states_([
		[ "Stop Hihat", q.color.white, q.color.red ],
		[ "Start Hihat", q.color.white, q.color.green ]
	])
	.action_{|v|
		( v.value == 1 ).if(
			{
			  Pdef(\hihat).stop;
		    },
			{
			  Pdef(\hihat).play;
		    }
		)
	};

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB] Define text label for REVERB X/Y control                                      */
  /* ---------------------------------------------------------------------------------------*/
  q.text.reverb = StaticText()
	.string_("Reverb")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB] Define REVERB X/Y control                                                     */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.reverb = Slider2D.new()
	.action_{
	  |v| q.fx.reverb.set(\room, v.x); q.fx.reverb.set(\damp, v.y)
     }
     // Value represented by horizontal position of the handle
	 .x_(0.8)
     // Value represented by vertical position of the handle
	 .y_(0.8);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB SHORT] Define text label for COMB (short) X/Y control                            */
  /* ---------------------------------------------------------------------------------------*/
  q.text.combA = StaticText()
	.string_("Comb (short)")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB SHORT] Define COMB (short) X/Y control                                           */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.combA = Slider2D.new()
	.action_{
	 |v| q.fx.combA.set(\decay, v.x/2); q.fx.combA.set(\delay, v.y/7.5)
    }
     // Value represented by horizontal position of the handle
	.x_(0.35*2)
     // Value represented by vertical position of the handle
	.y_(0.135);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB MIDDLE] Define text label for COMB (middle) X/Y control                          */
  /* ---------------------------------------------------------------------------------------*/
  q.text.combB = StaticText()
	.string_("Comb (middle)")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB MIDDLE] Define COMB (middle) X/Y control                                         */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.combB = Slider2D.new()
   .action_{
	  |v| q.fx.combB.set(\decay, v.x); q.fx.combB.set(\delay, v.y/7.5)
   }
	.x_(0.6)
	.y_(0.375);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB LONG] Define text label for COMB (long) X/Y control                              */
  /* ---------------------------------------------------------------------------------------*/
  q.text.combC = StaticText()
	.string_("Comb (long)")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB LONG] Define COMB (long) X/Y control                                             */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.combC = Slider2D.new()
	.action_{
	  |v| q.fx.combC.set(\decay, v.x*2); q.fx.combC.set(\delay, v.y/7.5)
    }
	.x_(1/2)
	.y_(0.75);

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB DRY WET] Define text label for reverb dry/wet mix slider control               */
  /* ---------------------------------------------------------------------------------------*/
  q.text.reverbMix = StaticText()
	.string_("Reverb dry / wet mix")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB DRY WET] Define reverb dry/wet mix slider control                              */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.reverbMix = Slider.new(w,Rect(width: q.slider.width))
	.action_{
	  |v| q.fx.reverb.set(\mix, v.value)
	}
	.value_(0.5);

  /* -------------------------------------------------------------------------------------- */
  /* [WINDOW & LAYOUT] Define Widget/Window and Layout                                      */
  /* ---------------------------------------------------------------------------------------*/
  /*
    Layout with VLayout and HLayout is pretty straightforward. Here we have a single
    VLayout which distributes its contained views vertically, top to bottom. Each row is
    implemented by a HLayout. Each view element in the HLayout is ordered left to right.
    Sizing is done automatically, with the exception of the sliders. When new Sliders
    are created their orientation is determined by their initial size. If a slider is
    wider than it is high, the orientation will be horizontal, otherwise vertical. More
    complex layouts can be nested inside VLayouts and HLayouts accordingly.
  */
  w = Window.new(name: q.window.title, bounds: q.window.bounds).layout_(
    VLayout (
		HLayout(q.text.transport),
		HLayout(q.button.start),
		HLayout(q.text.tempoString),
		HLayout(q.slider.tempo, q.text.tempo),
		HLayout(q.text.voices),
		HLayout(q.button.hihat),
		HLayout(q.text.reverb, q.text.combA, q.text.combB, q.text.combC),
		HLayout(q.slider.reverb, q.slider.combA, q.slider.combB, q.slider.combC),
		HLayout(q.text.reverbMix),
		HLayout(q.slider.reverbMix)
    )
  ).front;

  // Make voice button invisible by default
  q.button.hihat.visible_(false);

)

(
  // Print the current GUI Kit to the Post Window
  GUI.current.postln;
  // Print the q object
  q.postln;
)