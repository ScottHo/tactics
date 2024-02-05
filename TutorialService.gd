class_name TutorialService extends Node2D


@onready var jenkins: Jenkins = $"../Camera2D/CanvasLayer/MenuService/Jenkins"
@onready var menuService: MenuService = $"../Camera2D/CanvasLayer/MenuService"

enum TutorialStage { Start, Welcome, Moves, Attack, EndTurn1, DummyTurn1, Turn2,
                    SpecialAttack, DummySpecial, Turn3, Ultimate, End}
var stage: TutorialStage

func next_tutorial_stage():
    menuService.disableAllButtons(true)
    menuService.enable_turn_button(false, true)
    match stage:
        TutorialStage.Start:
            stage = TutorialStage.Welcome
            welcome()
        TutorialStage.Welcome:
            stage = TutorialStage.Moves
            moves()
        TutorialStage.Moves:
            stage = TutorialStage.Attack
            attack()
        TutorialStage.Attack:
            stage = TutorialStage.EndTurn1
            end_turn()
        TutorialStage.EndTurn1:
            stage = TutorialStage.DummyTurn1
            dummy_turn()
        TutorialStage.DummyTurn1:
            stage = TutorialStage.Turn2
            second_turn()
        TutorialStage.Turn2:
            stage = TutorialStage.SpecialAttack
            special()
        TutorialStage.SpecialAttack:
            stage = TutorialStage.DummySpecial
            dummy_special()
        TutorialStage.DummySpecial:
            stage = TutorialStage.Turn3
            third_turn()
        TutorialStage.Turn3:
            stage = TutorialStage.Ultimate
            ultimate()
        TutorialStage.Ultimate:
            stage = TutorialStage.End
            end()
    return

func welcome():
    var s = "Hello! Welcome to our training room.\n\n
Hold and drag right click to look around, and scroll wheel to zoom."
    menuService.jenkins_talk(s, Jenkins.Mood.HAPPY)
    get_tree().create_timer(5).timeout.connect(next_tutorial_stage)
    return

func moves():
    var s = "Each of our bots can be controlled using the bottom right panel \
it's their turn. Let's try moving. Click the move button, then click the tile you \
want to move to."
    menuService.jenkins_talk(s, Jenkins.Mood.NORMAL)
    menuService.enable_moves_button(true, true)
    return

func attack():
    var s = "Excellent. Now let's see how well you attack. Click the attack button \
and attack the target dummy"
    menuService.jenkins_talk(s, Jenkins.Mood.HAPPY)
    menuService.enable_attack_button(true, true)
    menuService.enable_moves_button(true, true)
    return

func end_turn():
    var s = "That's all for our turn. We can only do one of attack, special, or ultimate \
each turn.\n\nWe can move as much as we want until we run out of moves though! Let's end our turn \
with the next turn button"
    menuService.jenkins_talk(s, Jenkins.Mood.HAPPY)
    menuService.enable_turn_button(true, true)
    return

func dummy_turn():
    var s = "Now it's the dummy's turn to act. The Training Bot 1.0 comes equipped \
with a passive ability of increasing not only our armor but others around it, so we \
should take less damage."
    menuService.jenkins_talk(s, Jenkins.Mood.NORMAL)
    return

func second_turn():
    var s = "Time for our next turn! At the start of turn, the bot gains 1 Energy. \
Now we can use our special ability! Let's see how you do."
    menuService.jenkins_talk(s, Jenkins.Mood.NORMAL)
    menuService.enable_moves_button(true, true)
    menuService.enable_special_button(true, true)
    return

func special():
    var s = "The dummy has been weakened! Next time we attack it, it should deal 1 extra damage. \
\n\nThe amount of threat gained varies between attacks. The higher threat you have, the enemies want to \
attack you.\n\nLet's finish it off next turn."
    menuService.jenkins_talk(s, Jenkins.Mood.NORMAL)
    menuService.enable_turn_button(true, true)
    return

func dummy_special():
    var s = "Enemies also have special attacks. The training dummy will spawn a Cursed Gift. The next \
special it will use will heal it. Let's finish it off soon. \n\nI hear some foundry bots can use two \
specials a turn... scary."
    menuService.jenkins_talk(s, Jenkins.Mood.SAD)
    return

func third_turn():
    var s = "The interact button lets you pick up and store objects. Let's pick up the cursed gift.\
\nLike moving, interact can be done as many times as you want."
    menuService.jenkins_talk(s, Jenkins.Mood.NORMAL)
    menuService.enable_moves_button(true, true)
    menuService.enable_interact_button(true, true)
    return

func ultimate():
    var s = "I think it's time to show your true skills. Use your ultimate ability and finish the \
the mission!\n  Ultimate abilities are very powerful and do not have an energy cost, but can only be \
used once per mission."
    menuService.jenkins_talk(s, Jenkins.Mood.NORMAL)
    menuService.enable_moves_button(true, true)
    menuService.enable_ultimate_button(true, true)
    return

func end():
    var s = "Wow you are a skilled Coordinator. Maybe you will be the one to help us defeat \
Robo Corp."
    menuService.jenkins_talk(s, Jenkins.Mood.HAPPY)
    return

func start():
    stage = TutorialStage.Start
    next_tutorial_stage()
    return
