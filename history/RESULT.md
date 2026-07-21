# Task23 v153 结果

## Attempt 001: 无效节点性能重试

- Slurm job：`427739`，节点 `ACD1-14`。
- 现象：模型加载后每个 5-step chunk 约 20 秒；GPU 时钟正常但功耗约 120W，无法作为
  与 v152 的有效策略对照。
- 停止位置：仅到开门初始的 `t=15`，没有完整 episode、评分或视频。
- 结论：节点性能异常；取消后在不改代码、不改 seed、不改参数的前提下重试。

## Attempt 002: 有效成功复现

- Slurm job：`427751`，节点 `ACD1-4`，seed `105`，`replan=5`，`max_steps=2000`。
- 评分代码：RoboMemArena `62214036103ee8d5fef9b475dd8b344b6e2cfc03`，不允许旧 scorer fallback。
- Prompt：短 primitive VLA prompt；VLM 自主输出子任务，所有 `ORACLE_*` 均为 `0`。
- 外部运行目录：`task23_v153_v145_seed105_no_final_anchor_retry1_20260721_224300`。

| Stage | 结果 |
| --- | --- |
| `01_Open_Microwave` | Y |
| `02_Place_Cream_Microwave` | Y |
| `03_Place_Popcorn_Microwave` | Y |

- 远端 stage score：`100.0%`；stage-only TSR：`1/1`；BDDL goal：`1.0000`。
- VLM 路径：`open microwave -> pick cream -> place cream -> pick popcorn -> place popcorn`。
- `pick popcorn` 在 `t=631` hold；VLM 持续输出 `place popcorn`，在 `t=662` release。
  之后没有 `SUBTASK_RELEASE_ANCHOR`，机器人从真实抓取结束状态继续执行；第三个 stage 在
  `t=796` 完成。这验证了移除最终 robot-only anchor 的单变量假设。
- main video：`videos/task23/task23_success_ep0_seed105.mp4`（外部运行目录）。
- wrist video：`videos/task23/task23_success_ep0_seed105_wrist.mp4`（外部运行目录）。

外部运行产物 SHA256：

```text
d8bd3b4d06dbf909e89fda2c5ffd10249ba7ea94646d364c3096acf6f616ee62  summary.tsv
0d147d9f7e8949bdbb6c5fac83d722599fdccf47e5e0b7202a092e6c1b15100c  run_manifest.json
f8be3d4af25be0d0c5f4ee69a516842eb3ef4bf2289e03b434fa3646a0067c2a  task23/ep0/sync_vlm.log
4fbad3f6341bdbae383482174fb6c2705b4ab1b8282b7032b36c2d3651b67a29  task23_success_ep0_seed105.mp4
a529d8d68c1ea149f7a43525a68d48ca1890ed3b8a2bd84794c0822a54d5eec0  task23_success_ep0_seed105_wrist.mp4
```
