# README
apiサーバの実装サンプルです

## 仕様
* レコードの更新はdelete & insertで行う

## セットアップ
```
be rails db:drop && be rake db:create && rake db:migrate && rake db:seed
```

## 使い方
```console
be rails c
```
```
app.get('/order_requests', params: { account_id: 1 }) && JSON.parse(app.response.body)['next_url']
```
```
app.get('/order_requests', params: { account_id: 1, since: Date.new(2011, 1,1) }) && JSON.parse(app.response.body)['next_url']
```


## 動作確認

```
next_url = '/order_requests?account_id=1'
response = nil
loop do
  break if next_url.nil?
  app.get(next_url)
  response = JSON.parse(app.response.body)
  next_url = response['next_url']
end

OrderRequest.where(account_id: 1).count
```

ログ

```
irb(main):387:0* next_url = '/order_requests?account_id=1'
irb(main):388:0> response = nil
irb(main):389:0> loop do
irb(main):390:1*   break if next_url.nil?
irb(main):391:1>   app.get(next_url)
irb(main):392:1>   response = JSON.parse(app.response.body)
irb(main):393:1>   next_url = response['next_url']
irb(main):394:1> end
Started GET "/order_requests?account_id=1" for 127.0.0.1 at 2018-12-14 00:40:36 +0900
Processing by OrderRequestsController#index as HTML
  Parameters: {"account_id"=>"1"}
   (0.2ms)  SELECT MIN(`order_requests`.`id`) FROM `order_requests` WHERE `order_requests`.`account_id` = 1
   (0.2ms)  SELECT MAX(`order_requests`.`id`) FROM `order_requests` WHERE `order_requests`.`account_id` = 1
  OrderRequest Load (0.6ms)  SELECT  `order_requests`.* FROM `order_requests` WHERE `order_requests`.`account_id` = 1 AND (id > 0) AND (id <= 1990) ORDER BY `order_requests`.`id` ASC LIMIT 200
   (0.3ms)  SELECT MIN(`order_requests`.`id`) FROM `order_requests` WHERE (account_id = '1' and id > 390)
response ids: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390]
response count: 200
next_url: /order_requests?account_id=1&ghb=1990&glb=400
Completed 200 OK in 34ms (Views: 21.2ms | ActiveRecord: 2.3ms)


Started GET "/order_requests?account_id=1&ghb=1990&glb=400" for 127.0.0.1 at 2018-12-14 00:40:36 +0900
Processing by OrderRequestsController#index as HTML
  Parameters: {"account_id"=>"1", "ghb"=>"1990", "glb"=>"400"}
  OrderRequest Load (0.8ms)  SELECT  `order_requests`.* FROM `order_requests` WHERE `order_requests`.`account_id` = 1 AND (id > '400') AND (id <= 1990) ORDER BY `order_requests`.`id` ASC LIMIT 200
   (0.3ms)  SELECT MIN(`order_requests`.`id`) FROM `order_requests` WHERE (account_id = '1' and id > 790)
response ids: [401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 701, 702, 703, 704, 705, 706, 707, 708, 70
9, 710, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790]
response count: 200
next_url: /order_requests?account_id=1&ghb=1990&glb=800
Completed 200 OK in 30ms (Views: 23.9ms | ActiveRecord: 1.1ms)

[...]
```


## TODO
* レコードの挿入、更新処理
* テストコード書く
