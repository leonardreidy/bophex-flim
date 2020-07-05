/*
  Project: Bophex-Flim
  File: bos0n-flim--gui.scd
  Author: Bos0n
  Source: https://raw.githubusercontent.com/leonardreidy/bophex-flim/master/bos0n-flim--gui.scd
  Description: Refactor of the GUI of Rukano's Aphex Twin Flim project. The original source was
  incomplete. The refactor makes the following changes:

    - uses layout classes to manage the configuration and distribution of UI elements
    - reorders the UI elements into clearly defined and, where necessary, labelled groups
    - uses more intuitive class methods for defining colours
    - uses more intuitive colour scheme
    - eliminates redundant code and configuration
    - adds missing UI elements
    - removes broken volume controller
    - adds comments to make the code more understandable
*/

(

  /* -------------------------------------------------------------------------------------- */
  /* [INITIALIZATION] Initialize variables for UI components, colors, and dimensions        */
  /* ---------------------------------------------------------------------------------------*/

  // Components
  q.button = ();
  q.slider = ();
  q.window = ();
  q.color = ();
  q.text = ();
  q.line = ();

  // Colors
  q.color.orange = Color.fromHexString("#FF6600");
  q.color.mediumorange = Color.fromHexString("#ff8432");
  q.color.lightorange = Color.fromHexString("#ffb27f");

  q.color.green = Color.fromHexString("#00cc00");
  q.color.red = Color.fromHexString("#ff0000");

  q.color.blue = Color.fromHexString("#0099ff");
  q.color.mediumblue = Color.fromHexString("#32adff");
  q.color.lightblue = Color.fromHexString("#7fccff");

  q.color.black = Color.fromHexString("#000000");
  q.color.white = Color.fromHexString("#FFFFFF");

  q.color.lightgray = Color.fromHexString("#928c8c");
  q.color.darkgray = Color.fromHexString("#333333");

  // Dimensions
  q.window.width = 500;
  q.window.height = 600;

  q.slider.width = 50;


  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define text label for transport buttons                                    */
  /* ---------------------------------------------------------------------------------------*/
  q.text.transport = StaticText()
	.string_("Transport")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define START_ALL/STOP_ALL transport button                                 */
  /* ---------------------------------------------------------------------------------------*/

  q.button.start = Button.new()
	.states_([
		[ "START ALL", 	q.color.white, q.color.green ],
		[ "STOP ALL", 	q.color.white, q.color.red ]
	])
	.action_{|v|
		( v.value == 1).if(
			{
				Pdef(\ping).play;
				Pdef(\chord).play;
				Pdef(\kick).play;
				Pdef(\bass).play;
				Pdef(\hihat).play;
				Pdef(\snare).play;
				q.button.bass.valueAction_(0);
				q.button.kick.valueAction_(0);
				q.button.snare.valueAction_(0);
				q.button.hihat.valueAction_(0);

			},
			{ 	Pdef(\ping).stop;
				Pdef(\chord).stop;
				Pdef(\kick).stop;
				Pdef(\bass).stop;
				Pdef(\hihat).stop;
				Pdef(\snare).stop;
				Pdef(\pong).stop;
				Pdef(\chordB).stop;
				q.button.bass.valueAction_(1);
				q.button.kick.valueAction_(1);
				q.button.snare.valueAction_(1);
				q.button.hihat.valueAction_(1);
 			}
		)
	};

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define CHANGE TO SECOND PART/CHANGE TO FIRST PART transport button         */
  /* ---------------------------------------------------------------------------------------*/
  q.button.change = Button.new()
	.states_([
		[ "CHANGE TO SECOND PART", q.color.white, q.color.lightorange ],
		[ "CHANGE TO FIRST PART", q.color.white, q.color.lightblue ]
	])
	.action_{|v|
		( v.value == 1).if(
			{ Pdef(\ping).stop; Pdef(\chord).stop; Pdef(\pong).play; Pdef(\chordB).play; },
			{ Pdef(\ping).play; Pdef(\chord).play; Pdef(\chordB).stop; Pdef(\pong).stop; }
		)
	};

  /* -------------------------------------------------------------------------------------- */
  /* [TRANSPORT] Define text label for transport tempo slider control                       */
  /* ---------------------------------------------------------------------------------------*/
  q.text.tempoString = StaticText()
	.string_("Tempo")
	.stringColor_(q.color.mediumgray);

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
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [VOICES] Define BASS voice button                                                      */
  /* ---------------------------------------------------------------------------------------*/
  q.button.bass = Button.new()
	.states_([
		[ "Bass", q.color.white, q.color.red ],
		[ "Bass", q.color.white, q.color.green ]
	])
	.action_{|v|
		( v.value == 1 ).if(
			{ Pdef(\bass).stop },
			{ Pdef(\bass).play }
		)
	};

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
  /* [REVERB] Define text label for REVERB X/Y control                                      */
  /* ---------------------------------------------------------------------------------------*/
  q.text.reverb = StaticText()
	.string_("Reverb")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB] Define REVERB X/Y control                                                     */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.reverb = Slider2D.new()
	.action_{ |v| q.fx.reverb.set(\room, v.x); q.fx.reverb.set(\damp, v.y) }
	.x_(0.8)
	.y_(0.8);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB SHORT] Define text label for COMB (short) X/Y control                            */
  /* ---------------------------------------------------------------------------------------*/
  q.text.combA = StaticText()
	.string_("Comb (short)")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB SHORT] Define COMB (short) X/Y control                                           */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.combA = Slider2D.new()
	.action_{ |v| q.fx.combA.set(\decay, v.x/2); q.fx.combA.set(\delay, v.y/7.5) }
	.x_(0.35*2)
	.y_(0.135);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB MIDDLE] Define text label for COMB (middle) X/Y control                          */
  /* ---------------------------------------------------------------------------------------*/
  q.text.combB = StaticText()
	.string_("Comb (middle)")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB MIDDLE] Define COMB (middle) X/Y control                                         */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.combB = Slider2D.new()
   .action_{ |v| q.fx.combB.set(\decay, v.x); q.fx.combB.set(\delay, v.y/7.5) }
	.x_(0.6)
	.y_(0.375);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB LONG] Define text label for COMB (long) X/Y control                              */
  /* ---------------------------------------------------------------------------------------*/
  q.text.combC = StaticText()
	.string_("Comb (long)")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMB LONG] Define COMB (long) X/Y control                                             */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.combC = Slider2D.new()
	.action_{ |v| q.fx.combC.set(\decay, v.x*2); q.fx.combC.set(\delay, v.y/7.5) }
	.x_(1/2)
	.y_(0.75);

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB DRY WET] Define text label for reverb dry/wet mix slider control               */
  /* ---------------------------------------------------------------------------------------*/
  q.text.reverbMix = StaticText()
	.string_("Reverb dry / wet mix")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [REVERB DRY WET] Define reverb dry/wet mix slider control                              */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.reverbMix = Slider.new(w,Rect(width: q.slider.width))
	.action_{|v|
		q.fx.reverb.set(\mix, v.value)
	}
	.value_(0.5);

  /* -------------------------------------------------------------------------------------- */
  /* [COMPRESSOR SLOPES] Define text label for Compressor Slopes X/Y control                */
  /* ---------------------------------------------------------------------------------------*/
   q.text.compSlopes = StaticText()
    .string_("Compressor Slopes")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMPRESSOR SLOPES] Define Compressor Slopes X/Y control                               */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.compSlopes = Slider2D.new()
	.action_{ |v| q.compressor.set(\slopeA, v.x); q.fx.combC.set(\slopeB, v.y) }
	.x_(0.1)
	.y_(1);

  /* -------------------------------------------------------------------------------------- */
  /* [COMPRESSOR TIMES] Define text label for Compressor Times X/Y control                  */
  /* ---------------------------------------------------------------------------------------*/
  q.text.compTimes = StaticText()
    .string_("Compressor Times")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMPRESSOR TIMES] Define Compressor Times X/Y control                                 */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.compTimes = Slider2D.new()
	.action_{ |v| q.compressor.set(\clampT, v.y); q.fx.combC.set(\relaxT, v.x) }
	.x_(0.5)
	.y_(0.01);

  /* -------------------------------------------------------------------------------------- */
  /* [COMPRESSOR THRESHOLD] Define text label for Compressor Threshold slider control       */
  /* ---------------------------------------------------------------------------------------*/
  q.text.compThresh = StaticText()
    .string_("Compressor Threshold")
	.stringColor_(q.color.mediumgray);

  /* -------------------------------------------------------------------------------------- */
  /* [COMPRESSOR THRESHOLD] Define Compressor Threshold slider control                      */
  /* ---------------------------------------------------------------------------------------*/
  q.slider.compThresh = Slider.new(w,Rect(width: q.slider.width))
	.action_{|v| q.compressor.set(\thresh, v.value) }
	.value_(0.8);


  /* -------------------------------------------------------------------------------------- */
  /* [WINDOW & LAYOUT] Define Widget/Window and Layout                                      */
  /* ---------------------------------------------------------------------------------------*/
  w = Window.new(name:"Bophex Flim",bounds:Rect(left:400,top:100,width:q.window.width,height:q.window.height)).layout_(
    VLayout (
		HLayout(q.text.transport),
        HLayout(q.button.start),
		HLayout(q.button.change),
		HLayout(q.text.tempoString),
		HLayout(q.slider.tempo, q.text.tempo),
		HLayout(q.text.voices),
		HLayout(q.button.bass, q.button.kick, q.button.snare, q.button.hihat),
		HLayout(q.text.reverb, q.text.combA, q.text.combB, q.text.combC),
		HLayout(q.slider.reverb, q.slider.combA, q.slider.combB, q.slider.combC),
		HLayout(q.text.reverbMix),
		HLayout(q.slider.reverbMix),
		HLayout(q.text.compSlopes, q.text.compTimes),
		HLayout(q.slider.compSlopes, q.slider.compTimes),
		HLayout(q.text.compThresh),
		HLayout(q.slider.compThresh)
    )
  ).front;

  /* -------------------------------------------------------------------------------------- */
  /* [KEYBOARD SHORTCUTS] Define keyboard shortcuts                                         */
  /* -------------------------------------------------------------------------------------- */
  CmdPeriod.add({w.close});

  /* -------------------------------------------------------------------------------------- */
  /* [INFO] Print info to post window                                                       */
  /* -------------------------------------------------------------------------------------- */
  "-----------|| INFO ||-----------".postln;
  "Bophex Flim uses the QT GUI kit.".postln;
  "If your system does not default".postln;
  "to QT GUI, you may need to force.".postln;
  "".postln;
)

(
  // Print the current GUI Kit to the Post Window
  GUI.current.postln;
)