Movement States

| From\To | Crash     | Float          | FlyKick | Stand     | Run       | Glide | Crouch | Walk      | Slide  |
| ------- | --------- | -------------- | ------- | --------- | --------- | ----- | ------ | --------- | ------ |
| Crash   | X         | In Air         | X       | Time      | X         | X     | X      | X         | X      |
| Float   | Hard Land | X              | Crouch  | Soft Land | X         | X     | X      | X         | X      |
| FlyKick | X         | Jump           | X       | X         | X         | X     | X      | X         | Land   |
| Stand   | X         | Jump or In Air | X       | X         | Dir       | X     | Crouch | X         | X      |
| Run     | X         | Jump or In Air | X       | No Dir    | X         | X     | X      | X         | Crouch |
| Glide   | X         | Time           | Crouch  | X         | X         | X     | X      | X         | X      |
| Crouch  | X         | In Air         | X       | No Crouch | X         | Jump  | X      | Dir       | X      |
| Walk    | X         | In Air         | X       | X         | No Crouch | Jump  | No Dir | X         | X      |
| Slide   | X         | In Air         | X       | X         | No Crouch | Jump  | No Dir | No Motion | X      |

Melee Attack Type

```
Stand | Run => First Attack
First Attack => Second Attack
Second Attack => Third Attack
Crouch => Punch Face Direction
Crouch + Up => Punch Up + Face Direction
Crouch + Down => Punch Down + Face Direction
Air + Up => Swipe Cone
Air + Down => Slice Down
```

Range Attack

```
Air => Push Back
```

