# Task23 v153 变更说明

## 目标

验证 Task23 最后一段是否因 `pick popcorn -> place popcorn` 的 robot-only frame-165
reset 而破坏真实抓取状态。

## 唯一行为改动

从 release-anchor 配置中删除：

```text
released=pick popcorn, next=place popcorn, frame_idx=165
```

因此 VLM 自主输出 `place popcorn` 后，VLA 从真实 pick 结束状态继续执行，不读取或
应用该训练轨迹 anchor。

## 保持不变

- v152 的 VLM、VLA、短 primitive prompt、seed105、`replan=5`、`max_steps=2000`。
- VLM 自主 prompt 与全部 `ORACLE_*=0`。
- `open microwave -> pick cream` 和 `place cream -> pick popcorn` 的 robot-only anchor。
- `place popcorn` 不参与 EEF target/连续 hold。
- RoboMemArena `62214036103ee8d5fef9b475dd8b344b6e2cfc03` 评分与三项必需 stage。
