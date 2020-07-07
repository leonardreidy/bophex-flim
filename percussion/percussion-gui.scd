/**
  Project: Bophex-Flim
  File: percussion/percussion-gui.scd
  Author: Leonard M Reidy
  Source:
  Docs: [ http://supercollider.sourceforge.net/wiki/index.php/User_FAQ ]
  Description: This file contains a first run at isolating elements of the bophex-flim project for further analysis,
  specifically:

    - all percussion GUI controls in a single widget
    - all melody/harmony GUI elements removed from widget
    - a subset of the GUI controls for FX (reverb and combs)
    - tempo control
    - further improvments to comments
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
  q.text.transport = StaticText()
	.string_("Transport")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define START_ALL/STOP_ALL transport button                                 */
  /* ---------------------------------------------------------------------------------------*/
  q.button.start = Button.new()
	.states_([
		[ "Start", 	q.color.white, q.color.green ],
		[ "Stop", 	q.color.white, q.color.red ]
	])
	.action_{|v|
		(v.value == 1).if(
			{
			    Pdef(\kick).play;
				Pdef(\hihat).play;
			    Pdef(\snare).play;
				q.button.kick.valueAction_(0);
			    q.button.hihat.valueAction_(0);
			    q.button.snare.valueAction_(0);

			},
			{
			    Pdef(\kick).stop;
				Pdef(\hihat).stop;
			    Pdef(\snare).stop;
				q.button.kick.valueAction_(1);
			    q.button.hihat.valueAction_(1);
			    q.button.snare.valueAction_(1);
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
	.string_("Voices")
	.stringColor_(q.color.gray);

  /* -------------------------------------------------------------------------------------- */
  /* [VOICES] Define KICK voice button                                                      */
  /* ---------------------------------------------------------------------------------------*/
  q.button.kick = Button.new()
	.states_([
		[ "Kick", q.color.white, q.color.red ],
		[ "Kick", q.color.white, q.color.green ]
	])
	.action_{|v|
		( v.value == 1 ).if(
			{ Pdef(\kick).stop },
			{ Pdef(\kick).play }
		)
	};

  /* -------------------------------------------------------------------------------------- */
  /* [VOICES] Define HIHAT voice button                                                     */
  /* ---------------------------------------------------------------------------------------*/
  q.button.hihat = Button.new()
	.states_([
		[ "Hihat", q.color.white, q.color.red ],
		[ "Hihat", q.color.white, q.color.green ]
	])
	.action_{|v|
		( v.value == 1 ).if(
			{ Pdef(\hihat).stop },
			{ Pdef(\hihat).play }
		)
	};

  /* -------------------------------------------------------------------------------------- */
  /* [VOICES] Define SNARE voice button                                                     */
  /* ---------------------------------------------------------------------------------------*/
  q.button.snare = Button.new()
	.states_([
		[ "Snare", q.color.white, q.color.red ],
		[ "Snare", q.color.white, q.color.green ]
	])
	.action_{|v|
		( v.value == 1 ).if(
			{ Pdef(\snare).stop },
			{ Pdef(\snare).play }
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
     // Value represented by horizontal position of the handle
	.x_(0.6)
     // Value represented by vertical position of the handle
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
     // Value represented by horizontal position of the handle
	.x_(1/2)
     // Value represented by vertical position of the handle
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
  w = Window.new(name: q.window.title, bounds: q.window.bounds).layout_(
    VLayout (
		HLayout(q.text.transport),
		HLayout(q.button.start),
		HLayout(q.text.tempoString),
		HLayout(q.slider.tempo, q.text.tempo),
		HLayout(q.text.voices),
		HLayout(q.button.kick, q.button.hihat, q.button.snare),
		HLayout(q.text.reverb, q.text.combA, q.text.combB, q.text.combC),
		HLayout(q.slider.reverb, q.slider.combA, q.slider.combB, q.slider.combC),
		HLayout(q.text.reverbMix),
		HLayout(q.slider.reverbMix)
    )
  ).front;

)

(
  // Print the current GUI Kit to the Post Window
  GUI.current.postln;
  // Print the q object
  q.postln;
)