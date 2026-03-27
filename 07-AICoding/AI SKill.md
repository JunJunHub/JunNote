# AI Skills 技能库

自定义的 AI 技能定义文件存放在 [[SkillCustom]] 目录。

## 已创建的 Skills

### 代码可视化 Skill

**文件**：[[SkillCustom/code-visualization.skill.md]]

**用途**：使用 Mermaid 语法绘制专业的项目架构图、流程图、类图、时序图、状态机等图表。

**触发场景**：
- 绘制项目架构图 / 系统架构图
- 创建流程图 / 业务流程图
- 绘制类图 / UML 类图
- 创建时序图 / 序列图
- 绘制状态机图 / 状态图
- 梳理代码结构 / 代码梳理
- ER 图 / 实体关系图
- 甘特图 / 项目进度图

**兼容性**：Mermaid 8.8.0 及以上版本

---

## 项目级 Skill 使用方法

### 方法一：CLAUDE.md 引用（推荐）

在项目的 `CLAUDE.md` 文件中添加对 Skill 的引用：

```markdown
## Skills

本项目使用以下自定义 Skills：

- **代码可视化**：见 [[SkillCustom/code-visualization.skill.md]]
  - 触发词：架构图、流程图、类图、时序图、状态图
```

这样 Claude 在读取项目 CLAUDE.md 时会自动了解可用的 Skills。

### 方法二：会话内手动加载

在对话开始时，发送：

```
请阅读 SkillCustom/code-visualization.skill.md 并使用其中的指南
```

### 方法三：使用 Skill 文件名约定

将 Skill 文件命名为 `SKILL.md` 或放在 `.claude/skills/` 目录下（部分 Claude Code 版本支持）。

---

## Skill 文件结构

一个标准的 Skill 文件应包含：

| 章节 | 说明 |
|------|------|
| `## Description` | Skill 简介 |
| `## Triggers` | 触发场景关键词 |
| `## Skill Behavior` | 激活后的行为模式 |
| `## 示例/模板` | 具体的使用示例 |
| `## 注意事项` | 使用时的注意点 |
