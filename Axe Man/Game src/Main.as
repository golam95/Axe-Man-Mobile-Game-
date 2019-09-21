package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	public class Main extends MovieClip {

		private var bg_mc: MovieClip;
		private var gamehero_mc: MovieClip;
		private var gamehero_mc1: MovieClip;
		private var timer: Timer;
		private var rightZombiAppear: Timer;
		private var flag: Boolean;
		private var hero_X: int = 0;
		private var hero_Y: int = 0;
		private var previousKey: uint;


		private var gameScore: Number = 0;
		private var livedecrease: Number = 5;

		//bg_mc.txtgamescore.visible 


		private var hitbom_mc: MovieClip = new hitzombieClass();
		private var gameOver_mc: MovieClip = new gameOverClass();

		private var gamehighscore_mc: MovieClip = new highscorepanelclass();

		private var gameWin_mc: MovieClip = new winClass();



		private var bombsound_mc: MovieClip;
		private var zombiesound_mc: MovieClip;





		public function Main() {
			// constructor code
			bg_mc = new bgClass();
			addChild(bg_mc);

			gamehero_mc = new gameheroClass();
			addChild(gamehero_mc);
			gamehero_mc.x = 340;
			gamehero_mc.width = 130;
			gamehero_mc.height = 130;
			gamehero_mc.y = 120;
			gamehero_mc.visible = false;


			gamehero_mc1 = new herowithknifClass();
			addChild(gamehero_mc1);
			gamehero_mc1.width = 130;
			gamehero_mc1.height = 130;
			gamehero_mc1.visible = false;
			gamehero_mc1.hitext.visible = false;


			gameOver_mc.x = 350;
			gameOver_mc.y = 160;
			addChild(gameOver_mc);
			gameOver_mc.visible = false;


			gamehighscore_mc.x = 350;
			gamehighscore_mc.y = 160;
			addChild(gamehighscore_mc);
			gamehighscore_mc.visible = false;







			gameWin_mc.x = 350;
			gameWin_mc.y = 160;
			addChild(gameWin_mc);
			gameWin_mc.visible = false;



			//bg_mc.txtgamescore.visible 
			bg_mc.txtlive.text = livedecrease;



			bg_mc.score.visible = false;
			bg_mc.live.visible = false;
			bg_mc.timew.visible = false;
			bg_mc.txtlive.visible = false;


			timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, updateTimeHandler);



			rightZombiAppear = new Timer((rnd(1, 5) * 1000), 1);
			rightZombiAppear.addEventListener(TimerEvent.TIMER_COMPLETE, onrightzombieAppearTimer);

			bomInvisible();

			bg_mc.txtgamescore.visible = false;
			bg_mc.txt_timer.visible = false;
			bg_mc.btnstartgame.addEventListener(MouseEvent.CLICK, manageStartGame);
			bg_mc.btnhighscore.addEventListener(MouseEvent.CLICK, manageHighScore);



			gamehighscore_mc.txtcancel.addEventListener(MouseEvent.CLICK, manageCancel);
			gameOver_mc.txtcancel.addEventListener(MouseEvent.CLICK, manageCancel);
			gameWin_mc.txtcancel.addEventListener(MouseEvent.CLICK, manageCancel);
			stage.addEventListener(Event.ENTER_FRAME, eventHandleGame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}



		private function onrightzombieAppearTimer(event: TimerEvent): void {
			createrightZombie();
			rightZombiAppear.delay = rnd(1, 5) * 900;
			rightZombiAppear.start();
		}

		private function createrightZombie(): void {
			var rightzombie: zombierightClass = new zombierightClass();
			rightzombie.width = 70;
			rightzombie.height = 70;
			rightzombie.cacheAsBitmap = true;
			this.addChild(rightzombie);
			rightzombie.scaleX = -0.1;
			rightzombie.x = 900;
			rightzombie.y = rnd(100, 424);

			var rightzombieTimer: Timer = new Timer(20, 1);
			rightzombieTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			rightzombieTimer.start();

			function onTimer(event: TimerEvent): void {
				if ((flag == true)) {
					remove();
				}
				if ((flag == false)) {
					if (rightzombie.x > 330) {
						rightzombie.x -= 0.5;
						rightzombieTimer.start();

						if (rightzombie.hitTestObject(bg_mc.bom9) || rightzombie.hitTestObject(bg_mc.bom5) || rightzombie.hitTestObject(bg_mc.bom7) || rightzombie.hitTestObject(bg_mc.bom3) || rightzombie.hitTestObject(bg_mc.bom7) || rightzombie.hitTestObject(bg_mc.bomb1) || rightzombie.hitTestObject(bg_mc.bomb6) || rightzombie.hitTestObject(bg_mc.bomb10)) {



							bombsound_mc = new bombsoundClass();
							bombsound_mc.play();

							remove();
							addChild(hitbom_mc);
							livedecrease--;
							bg_mc.txtlive.text = String(livedecrease);
							hitbom_mc.x = rightzombie.x - 80;
							hitbom_mc.y = rightzombie.y;
							removezombie(hitbom_mc);
							//trace('Hit with boss');

						}

						if (gamehero_mc1.hitext != null) {

							if (gamehero_mc1.hitext.hitTestObject(rightzombie) == true) {

								zombiesound_mc = new zombiesoundclass();
								zombiesound_mc.play();

								remove();
								gameScore += 10;
								bg_mc.txtgamescore.text = String(gameScore);

							}


						}


						if (livedecrease <= 0) {

							showGameover();

						}

						if (gameScore == 250) {



							showWinpanel();
							scoreaddServer(gameScore);
						}



					} else {
						remove();
					}
				}
			}
			function remove(): void {
				if ((rightzombieTimer != null)) {
					rightzombieTimer.stop();
					rightzombieTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
					rightzombieTimer = null;

				}
				//check to see if the main movie clip contains our coin

				if (contains(rightzombie)) {
					removeChild(rightzombie);
				}
			}
		}

		private function showWinpanel(): void {

			flag = true;
			bomInvisible();
			rightZombiAppear.stop();
			gamehero_mc.visible = false;
			bg_mc.txt_timer.visible = false;
			gameWin_mc.visible = true;
			gameWin_mc.textscore.text = String(gameScore);
			bg_mc.txt_timer.text = String(0);

			bg_mc.score.visible = false;
			bg_mc.live.visible = false;
			bg_mc.timew.visible = false;
			bg_mc.txtlive.visible = false;
			bg_mc.txtgamescore.visible = false;
			bg_mc.herotitle.visible = true;

		}

		private function showGameover(): void {

			flag = true;
			bomInvisible();
			rightZombiAppear.stop();
			gamehero_mc.visible = false;
			bg_mc.txt_timer.visible = false;
			gameOver_mc.visible = true;

			gameOver_mc.textscore.text = String(gameScore);
			bg_mc.txt_timer.text = String(0);




			bg_mc.score.visible = false;
			bg_mc.live.visible = false;
			bg_mc.timew.visible = false;
			bg_mc.txtlive.visible = false;
			bg_mc.txtgamescore.visible = false;
			bg_mc.herotitle.visible = true;



		}




		//btn_start;

		private function manageStartGame(event: MouseEvent): void {
			createrightZombie();
			rightZombiAppear.start();
			visiblegameMatirial();
			bomVisible();

		}

		private function manageHighScore(event: MouseEvent): void {

			gamehighscore_mc.visible = true;
			bg_mc.btnstartgame.visible = false;
			bg_mc.btnhighscore.visible = false;
			fetchvalue();


		}


		private function manageCancel(event: MouseEvent): void {
			gameOver_mc.visible = false;
			gameWin_mc.visible = false;
			bg_mc.btnstartgame.visible = true;
			bg_mc.btnhighscore.visible = true;

			bg_mc.score.visible = false;
			bg_mc.live.visible = false;
			bg_mc.timew.visible = false;
			bg_mc.txtlive.visible = false;
			gamehero_mc.visible = false;
			bg_mc.txtgamescore.visible = false;
			gamehighscore_mc.visible = false;
			timer.reset();
			bg_mc.txt_timer.text = String(0);

			gameScore = 0;
			livedecrease = 5;

			bg_mc.txtgamescore.text = gameScore;
			bg_mc.txtlive.text = livedecrease;


		}


		private function visiblegameMatirial(): void {
			gamehero_mc.visible = true;
			bg_mc.txtgamescore.visible = true;
			bg_mc.score.visible = true;
			bg_mc.live.visible = true;
			bg_mc.timew.visible = true;
			bg_mc.txtlive.visible = true;



			bg_mc.txt_timer.visible = true;
			bg_mc.herotitle.visible = false;
			bg_mc.btnstartgame.visible = false;
			bg_mc.btnhighscore.visible = false;
			flag = false;
			timer.reset();
			timer.start();

		}
		public function updateTimeHandler(event: TimerEvent): void {

			bg_mc.txt_timer.text = String(timer.currentCount);

			if (timer.currentCount == 25) {

				timer.stop();
				timer.reset();
				showGameover();

			}

		}
		private function rnd(min: Number, max: Number): Number {
			var randomNum: Number = Math.floor(Math.random() * ((max - min) + 1)) + min;
			return randomNum;
		}

		public function keyDownHandler(event: KeyboardEvent): void {

			if (event.keyCode == Keyboard.UP) {

				hero_Y = -5;

			} else if (event.keyCode == Keyboard.DOWN) {
				hero_Y = 5;

			} else if (event.keyCode == Keyboard.B) {

				gamehero_mc1.visible = true;
				gamehero_mc.visible = false;

			}
		}

		public function keyUpHandler(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP) {
				hero_Y = 0;

			} else if (event.keyCode == Keyboard.B) {
				gamehero_mc.visible = true;
				gamehero_mc1.visible = false;


			}
		}
		private function eventHandleGame(e: Event): void {
			gamehero_mc.x += hero_X;
			gamehero_mc.y += hero_Y;
			checkBoundary();
			gamehero_mc1.x = gamehero_mc.x;
			gamehero_mc1.y = gamehero_mc.y;

		}

		private function bomInvisible(): void {

			bg_mc.bom2.visible = false;
			bg_mc.bom3.visible = false;
			bg_mc.bom4.visible = false;
			bg_mc.bom5.visible = false;
			bg_mc.bom6.visible = false;
			bg_mc.bom7.visible = false;
			bg_mc.bom8.visible = false;
			bg_mc.bom9.visible = false;

			bg_mc.bomb1.visible = false;
			bg_mc.bomb2.visible = false;
			bg_mc.bomb3.visible = false;
			bg_mc.bomb4.visible = false;
			bg_mc.bomb5.visible = false;
			bg_mc.bomb6.visible = false;
			bg_mc.bomb7.visible = false;
			bg_mc.bomb8.visible = false;
			bg_mc.bomb9.visible = false;
			bg_mc.bomb10.visible = false;
			bg_mc.bomb11.visible = false;
			bg_mc.bomb12.visible = false;
		}
		private function bomVisible(): void {

			bg_mc.bom2.visible = true;
			bg_mc.bom3.visible = true;
			bg_mc.bom4.visible = true;
			bg_mc.bom5.visible = true;
			bg_mc.bom6.visible = true;
			bg_mc.bom7.visible = true;
			bg_mc.bom8.visible = true;
			bg_mc.bom9.visible = true;

			bg_mc.bomb1.visible = true;
			bg_mc.bomb2.visible = true;
			bg_mc.bomb3.visible = true;
			bg_mc.bomb4.visible = true;
			bg_mc.bomb5.visible = true;
			bg_mc.bomb6.visible = true;
			bg_mc.bomb7.visible = true;
			bg_mc.bomb8.visible = true;
			bg_mc.bomb9.visible = true;
			bg_mc.bomb10.visible = true;
			bg_mc.bomb11.visible = true;
			bg_mc.bomb12.visible = true;
		}
		private function removezombie(zombie_mc: MovieClip): void {
			setTimeout(function () {
				if (contains(zombie_mc)) {
					removeChild(zombie_mc);
				}
			}, 1000);
		}

		private function checkBoundary(): void {

			if (gamehero_mc.y <= 0) {
				gamehero_mc.y = 3;
			} else if (gamehero_mc.y >= 380) {
				gamehero_mc.y = 380;
			}
		}


		private function scoreaddServer(gameScore: int): void {

			var getScore: int = gameScore;

			if ((getScore != 0)) {

				var variables: URLVariables = new URLVariables();
				variables.myscore = getScore;

				var request: URLRequest = new URLRequest('http://localhost/zombie/Score.php');
				request.method = URLRequestMethod.POST;
				request.data = variables;

				var loader: URLLoader = new URLLoader(request);
				loader.dataFormat = URLLoaderDataFormat.VARIABLES;
				loader.addEventListener(Event.COMPLETE, dataOnLoad);
				loader.load(request);
			}


		}

		function dataOnLoad(e: Event) {

			var variables: URLVariables = URLVariables(e.target.data);

		}

		private function fetchvalue(): void {

			var phpVars: URLVariables = new URLVariables();
			phpVars.systemCall = "process";

			var phpFileRequest: URLRequest = new URLRequest('http://localhost/zombie/fetch.php');
			phpFileRequest.method = URLRequestMethod.POST;
			phpFileRequest.data = phpVars;

			var phpLoader: URLLoader = new URLLoader();
			phpLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			phpLoader.addEventListener(Event.COMPLETE, showResult);
			phpLoader.load(phpFileRequest);

		}
		function showResult(e: Event): void {

			var strvalue: String = e.target.data.result;
			gamehighscore_mc.highscore.text = strvalue;

		}



	}

}