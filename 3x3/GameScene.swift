//
//  GameScene.swift
//  3x3
//
//  Created by Yoshiki Izumi on 2020/12/09.
//

import SpriteKit
import GameplayKit

class Stage {
    static let FRAME = 50
    var goal = false
    var goalFrame = Stage.FRAME
    var start = false

    var pointLabelEnemy = SKLabelNode(text: "0")
    var pointLabelTeam = SKLabelNode(text: "0")
    var pointLabel = SKLabelNode(text: "vs")
    var pointTeam: Int = 0
    var pointEnemy: Int = 0
    init() {
        pointLabel.setScale(3.0)
        pointLabelTeam.setScale(3.0)
        pointLabelEnemy.setScale(3.0)
    }
}
class Object {
    static let FRAME = 100
    static let RANGE: CGFloat = 50
    static let DURATION: CGFloat = 0.97
    var sprite: SKSpriteNode?
    var animation = false
    var speedX: CGFloat = 0.0
    var speedY: CGFloat = 0.0
    var frame = Object.FRAME


    func setPosition(x: CGFloat, y: CGFloat) {
    }
    func hitFrame(bounds: CGRect) {
        if sprite!.position.x < -bounds.width {
            speedX *= -1
        }
        if sprite!.position.x > bounds.width {
            speedX *= -1
        }
        if sprite!.position.y < -bounds.height {
            speedY *= -1
        }
        if sprite!.position.y > bounds.height {
            speedY *= -1
        }
    }
}
class Enemy: Object {
    static let MOVE_ANIMATION_FRAME = 200
    var moveAnimationFrame = Enemy.MOVE_ANIMATION_FRAME
    override init() {
        super.init()
        sprite = SKSpriteNode(imageNamed: "dragonRight")
        sprite?.setScale(0.06)
    }
    override func setPosition(x: CGFloat, y: CGFloat) {
        sprite?.position.x = x
        sprite?.position.y = y
    }
    func moveAnimation1Slide() {
        if moveAnimationFrame > Enemy.MOVE_ANIMATION_FRAME / 4 * 3 || moveAnimationFrame <= Enemy.MOVE_ANIMATION_FRAME / 4 * 1 {
            sprite?.position.x += 2
            moveAnimationFrame -= 1
        } else if moveAnimationFrame <= Enemy.MOVE_ANIMATION_FRAME / 4 * 3 &&
                    moveAnimationFrame > Enemy.MOVE_ANIMATION_FRAME / 4 * 1 {
            sprite?.position.x -= 2
            moveAnimationFrame -= 1
        }
        if moveAnimationFrame <= 0 {
            moveAnimationFrame = Enemy.MOVE_ANIMATION_FRAME
        }
    }
    func moveAnimation2Circle(currentTime: TimeInterval) {
        sprite?.position.x += CGFloat(cos(currentTime * 2) * 5 )
        sprite?.position.y += CGFloat(sin(currentTime * 2) * 3 )
    }
    func moveAnimation3Tracking(pos: CGPoint) {
        let x = (pos.x - sprite!.position.x)
        let y = (pos.y - sprite!.position.y)
        if x * x + y * y > 20000 {
            sprite?.position.x += x / 100
            sprite?.position.y += y / 100
        }
    }
}
class Player: Object {
    var origin = SKSpriteNode(imageNamed: "dragon2")
    var touch = false
    override init() {
        super.init()
        sprite = SKSpriteNode(imageNamed: "dragon2")
        sprite?.setScale(0.04)
        origin.setScale(0.04)
    }
    override func setPosition(x: CGFloat, y: CGFloat) {
        sprite?.position.x = x
        sprite?.position.y = y
        origin.position.x = x
        origin.position.y = y
    }
}

class Ball: Object {
    override init() {
        super.init()
        sprite = SKSpriteNode(imageNamed: "ball")
        sprite?.setScale(0.25)
    }
    override func setPosition(x: CGFloat, y: CGFloat) {
        sprite?.position.x = x
        sprite?.position.y = y
    }
    override func hitFrame(bounds: CGRect) {
        if sprite!.position.x < -bounds.width {
            speedX *= -1
        }
        if sprite!.position.x > bounds.width {
            speedX *= -1
        }
        if sprite!.position.y < -bounds.height {
            if sprite!.position.x < -bounds.width / 2 || sprite!.position.x > bounds.width / 2 {
                speedY *= -1
            }
        }
        if sprite!.position.y > bounds.height {
            if sprite!.position.x < -bounds.width / 2 || sprite!.position.x > bounds.width / 2 {
                speedY *= -1
            }
        }

    }
}

class GameScene: SKScene {
    
    var enemys: [Enemy] = [Enemy(), Enemy(), Enemy()]
    var team: [Player] = [Player(), Player(), Player()]
    var ball = Ball()
    var stage: Stage = Stage()
    
    override func didMove(to view: SKView) {
        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }

        initilize()
        
        for player in team {
            addChild(player.sprite!)
            addChild(player.origin)
        }
        for enemy in enemys {
            addChild(enemy.sprite!)
        }
        addChild(ball.sprite!)
        addChild(stage.pointLabelEnemy)
        addChild(stage.pointLabelTeam)
        addChild(stage.pointLabel)
    }
    
    func initilize() {
        stage.pointLabelTeam.position.y = -100
        stage.pointLabelEnemy.position.y = 100
        ball.speedX = 0.0
        ball.speedY = 0.0
        ball.sprite?.position.x = 0
        ball.sprite?.position.y = 0

        team[0].setPosition(x: 0, y: -200)
        team[1].setPosition(x: -200, y: -400)
        team[2].setPosition(x: 200, y: -400)
        
        enemys[0].setPosition(x: 0, y: 200)
        enemys[1].setPosition(x: -200, y: 400)
        enemys[2].setPosition(x: 200, y: 400)
        enemys[0].moveAnimationFrame = Enemy.MOVE_ANIMATION_FRAME
        enemys[1].moveAnimationFrame = Enemy.MOVE_ANIMATION_FRAME
        enemys[2].moveAnimationFrame = Enemy.MOVE_ANIMATION_FRAME

    }
    func touchDown(atPoint pos : CGPoint) {
        for player in team {
            if player.sprite!.position.x < pos.x + 100 &&
            player.sprite!.position.x > pos.x - 100 &&
            player.sprite!.position.y < pos.y + 100 &&
                player.sprite!.position.y > pos.y - 100 {
                player.touch = true
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if pos.x <= -view!.bounds.width {
            for player in team {
                player.touch = false
                player.animation = true
                player.speedX = (player.origin.position.x - player.sprite!.position.x) / 10
                player.speedY = (player.origin.position.y - player.sprite!.position.y) / 10
            }
        }
        if pos.x >= view!.bounds.width {
            for player in team {
                player.touch = false
                player.animation = true
                player.speedX = (player.origin.position.x - player.sprite!.position.x) / 10
                player.speedY = (player.origin.position.y - player.sprite!.position.y) / 10
            }
        }
        if pos.y <= -view!.bounds.height {
            for player in team {
                player.touch = false
                player.animation = true
                player.speedX = (player.origin.position.x - player.sprite!.position.x) / 10
                player.speedY = (player.origin.position.y - player.sprite!.position.y) / 10
            }
        }
        if pos.y >= view!.bounds.height {
            for player in team {
                player.touch = false
                player.animation = true
                player.speedX = (player.origin.position.x - player.sprite!.position.x) / 10
                player.speedY = (player.origin.position.y - player.sprite!.position.y) / 10
            }
        }

        for player in team {
            if player.touch {
                player.sprite?.position = pos
            }
        }
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        for player in team {
            if player.touch {
                player.touch = false
                player.animation = true
                player.speedX = (player.origin.position.x - player.sprite!.position.x) / 10
                player.speedY = (player.origin.position.y - player.sprite!.position.y) / 10
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if stage.goal {
            stage.goalFrame -= 1
            if stage.goalFrame <= 0 {
                stage.start = false
                stage.goal = false
                stage.goalFrame = Stage.FRAME
                initilize()
            }
        } else {
            if ball.sprite!.position.y > view!.bounds.height + 20.0 {
                stage.pointTeam += 1
                stage.pointLabelTeam.text = stage.pointTeam.description
                stage.goal = true
            }
            
            if ball.sprite!.position.y < -view!.bounds.height - 20.0 {
                stage.pointEnemy += 1
                stage.pointLabelEnemy.text = stage.pointEnemy.description
                stage.goal = true
            }
        }
        
        if stage.start {
            enemys[0].moveAnimation3Tracking(pos: ball.sprite!.position)
//            enemys[0].moveAnimation2Circle(currentTime: currentTime)
            enemys[1].moveAnimation1Slide()
            enemys[2].moveAnimation1Slide()
        }
        
        for enemy in enemys {
            enemy.hitFrame(bounds: view!.bounds)
            
            if enemy.frame > 0 {
                if enemy.animation {
                    enemy.sprite!.position.x += enemy.speedX
                    enemy.sprite!.position.y += enemy.speedY
                    enemy.frame -= 1
                    enemy.speedX *= Object.DURATION
                    enemy.speedY *= Object.DURATION
                }
            } else {
                enemy.animation = false
                enemy.frame = Object.FRAME
                enemy.speedX = 0.0
                enemy.speedY = 0.0
            }
        }
        for player in team {
            player.hitFrame(bounds: view!.bounds)
            
            if player.frame > 0 {
                if player.animation {
                    player.sprite!.position.x += player.speedX
                    player.sprite!.position.y += player.speedY
                    player.frame -= 1
                    player.speedX *= Object.DURATION
                    player.speedY *= Object.DURATION
                }
            } else {
                player.animation = false
                player.frame = Object.FRAME
                player.speedX = 0.0
                player.speedY = 0.0
                player.origin.position = player.sprite!.position
            }
        }

        ball.hitFrame(bounds: view!.bounds)

        if ball.frame > 0 {
            if ball.animation {
                ball.sprite!.position.x += ball.speedX
                ball.sprite!.position.y += ball.speedY
                ball.frame -= 1
                ball.speedX *= Object.DURATION
                ball.speedY *= Object.DURATION
            }
        } else {
            ball.animation = false
            ball.frame = Object.FRAME
            ball.speedX = 0.0
            ball.speedY = 0.0
        }

        for player in team {
            if player.animation {
                if player.sprite!.position.x < ball.sprite!.position.x + Object.RANGE &&
                player.sprite!.position.x > ball.sprite!.position.x - Object.RANGE &&
                player.sprite!.position.y < ball.sprite!.position.y + Object.RANGE &&
                    player.sprite!.position.y > ball.sprite!.position.y - Object.RANGE {
                    
                    stage.start = true
                    
                    ball.animation = true
                    ball.frame = player.frame
                    ball.speedX = player.speedX
                    ball.speedY = player.speedY
                        
                        
                    player.animation = false
                    player.frame = Object.FRAME
                    player.speedX = 0.0
                    player.speedY = 0.0
                    player.origin.position = player.sprite!.position
                }
            }
        }
        for enemy in enemys {
//            if player.animation {
                if enemy.sprite!.position.x < ball.sprite!.position.x + Object.RANGE &&
                    enemy.sprite!.position.x > ball.sprite!.position.x - Object.RANGE &&
                    enemy.sprite!.position.y < ball.sprite!.position.y + Object.RANGE &&
                    enemy.sprite!.position.y > ball.sprite!.position.y - Object.RANGE {
                    
//                    ball.animation = true
//                    ball.frame = player.frame
                    enemy.animation = true
                    enemy.frame = ball.frame
                    enemy.speedX = ball.speedX
                    enemy.speedY = ball.speedY
                    
                    ball.speedX *= -1
                    ball.speedY *= -1
                }
//            }
        }

    }
}
