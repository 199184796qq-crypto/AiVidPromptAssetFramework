# H3 官方全参考标签与素材对应规则

来源：https://github.com/MiniMax-AI/MiniMax-H3/blob/main/skills/h3-prompt-writing/references/ref-en.txt
核对日期：2026-09-08。本文为操作摘要，原文为 Full-Reference Mode Rewrite Output Format Guide。

## 适用边界与优先关系
只在 H3 全参考改写中使用完整六字段规则；基础文生、首尾帧使用对应基础指南，不强套全参考结构。双模型技能仅对 H3 分支适用。当前用户的明确语言、素材和交付要求优先；节点专用的分段分隔符、Latent Guide 和输入封装按节点实际协议。以下规则更新旧模板中与官方标签含义、音频引用、编号及全参考结构冲突的写法。中文讲解或资产清单中的 @图片 不是官方全参考正文标签，生成正文时建立并复用明确映射。

## 六字段与语言
顺序：subject_definitions → summary → retention_analysis → detailed_description → overall_soundscape → non_diegetic_music。默认六部分用英文；对白、歌词、画面可见文字保留原语言。用户明确要求中文等其他语言时遵从，并说明属于用户定制。summary 使用实际任务类型前缀（如 [reference generation]）；仅上传视频不等于 video editing，参考音色不等于 audio reuse。不得在 summary 新增未定义标签。

## 素材、主体和镜头
- subject_definitions 对每项后续需要独立追踪的内容单独成行，定义来源、用途和需保持的特征；标签在各字段及镜头中保持同一含义。
- <Subject N> 是可复用的可见内容，可为人物、动物、物体、场景、服装、动作、姿态、风格等，不是源文件编号。一主体可来自多份素材，一素材也可提供多个主体；逐项说明来源贡献。
- <Picture N> 仅作为主体来源时写在该 Subject 定义内，不另造独立图片条目；图片承担首帧、尾帧、关键帧、构图或分镜锚点时，独立说明对应镜头和用途。
- <Video N> 表示编辑源、续接起点、运镜/剪辑/节奏等整体关系；其中抽取的人物或动作仍用 Subject 定义。
- 重要主体首次清楚出镜时，写明参考特征、画面位置与当前动作；后续继续使用原标签。不能只列素材对应关系而缺少实际镜头描述。

## 保留范围
retention_analysis 逐项记录标签的出现镜头、用途和具体保留特征。视觉关系固定值为 fully_preserved、partially_preserved、attribute_transfer、weak_reference。fully_preserved 仅指已定义参考职责完整保留，不代表整张图逐像素复制，也不禁止新动作、新背景或新剧情。
音频关系为 fully_copy（源音频完整充当成片完整音轨）、partially_copy、reference、weak_reference。仅参考角色音色用 reference，不能写成 fully_copy。此字段不写 (Sx)。

## 声音、人物、台词对应
- <Audio N> 代表实际音频素材或明确启用的视频同步音轨。视频自带声音不自动产生 Audio；Video 和 Audio 独立编号，同号不代表自动配对。未提供声音素材时不得虚构 Audio 标签，也不要求每个角色必须有音频附件。
- 声音绑定在 subject_definitions 中明确写成 <Audio 1> 为 <Subject 3> (S1) 的音色参考。对应镜头或声音生效阶段可再次引用 Audio，官方并未禁止在 detailed_description 中出现 Audio。
- <Subject N> 是视觉主体，(Sx) 是实际发声者；编号不要求相等。按目标视频实际首次发声顺序分配 S1、S2，后续发声复用。音频定义复用该编号，不独立另编号。同一人物画外发声也保持编号并标注 off-screen。
- 正式对白模式：<Subject 3> (S1) says softly, <d>[Chinese] 你终于回来了.</d>。身份、动作、语气写在 d 外；d 内是语言标记和实际对白/歌词，不用于锁图片或显示字幕。
- 直接复用或明确要求重演参考台词时保留原词与语言；听不清写 [unclear]，不猜写。按官方规则规范基本标点，完整句以 .、? 或 ! 结束。只参考音色、节奏或情绪时，不把源音频台词带入成片。
- 被复用配乐中的歌词仅作为动作提示且无独立人物实际发声时，使用 Audio 来源，不凭空创造 Sx。
- 完整台词/歌词只在 detailed_description 的 d 中出现，不在 overall_soundscape 或 non_diegetic_music 重复。独立给用户看的时间轴对白清单可用人名，不算模型正文重复。

## 镜头与交付检查
全参考风格开头放在 detailed_description 的首镜之前；[Shot 1] 不带时间戳，后续真实切镜用 [Shot N] At MM:SS.mmm。普通动作时间点不等于切镜。跨切对白及结尾截断涉及 <scenetrans>、<cutoff> 时查基础指南，不自行发明嵌套语法。
生成正文通常为 350–500 英文词，按实际时长和对白容量安排，不机械凑字。环境/物理声归 overall_soundscape，观众听到的非叙事配乐归 non_diegetic_music，无配乐写 N/A。
交付前检查来源→主体→保留特征→实际镜头→发声者→台词是否一致。标签是官方规定的结构化约束表达，不是百分之百锁脸、锁字、对口型或无串音的质量保证。禁字幕、补光细则等现有项目偏好不应冒称为本指南官方要求。
