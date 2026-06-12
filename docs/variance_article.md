# Own the workflow, rent the model

There are a few standard paths for trying to integrate LLMs into real workflows. 

You can:
- Wait until your existing vendors implement AI features in their products inside the tools you already use, like an Excel add-in that is in the Excel menu ribbon. 
- Subscribe to chatbot based AI tool and leave it up to staff to figure out how to apply it to their work, like Claude or ChatGPT. 
- Subscribe to a new AI powered tool or service and train your employees how to use the new tool. 
- Build your own software (or hire consultants to build it) and train your employees how to use the new tool. 

Most of the conversation about which path to take is really about tradeoffs between cost, control, training, and dependence. There's another viable option people skip past entirely.

## A better option: files and instructions, not software

What people are missing about this question is that anyone can build a small system of files and instructions that lets you swap LLMs in and out at your discretion. If a smarter or cheaper model is released next quarter, you don't have to run a vendor selection process that touches your whole workflow and takes six months to evaluate. You change a setting. The workflow keeps running.

The solution to this problem is creating an environment where the workflow logic lives outside the model, on your own system. In a previous article I wrote about using a minimal harness, really just a small file system of folders containing instructions, examples, schemas, and output requirements that serves as the structure for getting a model to do the work the way you want. The model becomes the interchangeable piece. 

The surprising aspect of this setup is that the instruction files are just text files that describe the step-by-step workflow for any task, no code at all. This allows almost anyone to put models to work in their workflows without becoming or hiring an AI Engineer. 

## Key idea - A model harness does not have to be a software program

The Claude Code is a harness, OpenAI's Codex is a harness, and the ChatGPT app is a harness. They have different capabilities built into them but they all include some kind of background orchestration with the goal of answering the user's query. If you are using a frontier model from one of the main model providers, you are likely using a harness they have developed to get the best performance out of the model.  

The idea of a harness around LLMs is so important. The harness around a model is the code that:
- determines what step comes next in the workflow
- retrieves the information the model needs for each step
- enforces output requirements
- saves artifacts throughout the workflow
- retries failed steps
- continues long or paused workflows
- applies guardrails around what the model is allowed to do

Most of the difficulty in real workflows is not the model's reasoning. It's the context: what files to read, what fields to extract, what to do when the data is messy, what the output should look like when it gets handed off downstream. That context can live in your folders. It does not need to live inside a vendor's product.

## A minimal harness lets you ride model improvements without rebuilding

This matters because frontier models are improving constantly. New capabilities, higher prices, better instruction following, and longer context. New models with new capabilities show up every few months. If your workflow is wired into one vendor's product, every one of those improvements becomes a switching-cost decision instead of a quick upgrade.

When you can define a workflow in a folder structure instead, the same instructions can drive one model today, a different model tomorrow, and something that doesn't exist yet next year.

## Automation example - Variance Analysis

In this article and linked video, I'm going to walk through using this file system based approach with two different models to automate a task. Starting with a very simple workflow, here are the exact steps I went through to automate the process to turn trial balance CSVs to a real Excel analysis with the data compiled, linked, analyzed, with questions ready to go for further research.

The basic workflow looks like this:
- Compare 2 years of year-end account balances in Excel
- For accounts with large or unexpected variances, review additional data or work with the client to determine what contributed to the change.
- Determine if the change is reasonable or if additional explanation or testing is needed in any area. 

## How to think about building your own harness

For most of the workflows I've built, this comes down to two main files: 
- AGENTS.md - An instruction file describing the overall project goals
- SKILL.md files to give details about the step by step workflows the agent will execute

Other options include having a folder of examples showing the model what good output looks like, a schema or template to follow, and any reference material the model needs to do the job. 

## AGENTS.md

The AGENTS.md file describes the kind of work performed in the workspace, I keep them as short as possible but at least they will layout where skills files or reference files live, and where files should be saved to. 

For this example, the file includes instructions including:
- expected tasks it will complete
- examples of questions to ask the user if clarification is needed
- output requirements including: file type, naming conventions, tab names, and output location. 

## SKILL.md 

There is just one SKILL.md file for this simple task. It's the file that actually describes step by step workflow or task I need to automate. While I described the task above as "compare 2 years of year-end account balances in Excel," the reality is there actually a lot more tedious steps to the task than what is implied by that characterization. 

This file instructs the model for to perform all the steps a person would go through: 
- detect columns and normalize values
- build key of values to compare (i.e account number)
- create comparison fields with Excel formulas
- apply thresholds to generate analysis notes and client questions
- sort to apply to the resulting analysis
- create a summary tab to document the process and analysis results
- filenames to follow for generated output

To ensure the output is consistent and repeatable, the SKILL.md file also directs the what the Excel output should look like: 
- `Summary` tab that includes details about the:
    - source files for the analysis
    - purpose of the analysis
    - thresholds used for generating research questions
    - details about the data in each file
    - data validation details 
- `Prior_Year_TB` tab that includes the exact source file used. 
- `Prior_Year_TB` tab that includes the exact source file used. 
- `Comparison` tab that includes the normalized account details with formulas linking the account numbers to the source tabs with SUMIF formulas. Also, I'm telling the model to apply a dollar and a percent threshold to the account variances and then create follow-up questions to answer for the large variances. 

## Demo - Watch 3 different models/harnesses complete the task

If you don't want to watch the videos, the short summary is that all three models produced high-quality excel spreadsheets that have a summary of results tab, source tabs for each input file, and a tab with accurate formulas that reference the source files to perform the annual comparison. All three files also applied the threshold accurately and included appropriate follow-up questions that should be answered before the work paper is complete. 

Here's a video of Codex completing the task:

Here's a video of Claude Code completing the task:

Here's a video of my own AI agent completing the task:

## Lessons

This approach of file and instruction based workspaces working with capable AI models is the easiest and most durable way to automate workflows. Most AI-powered tools built for 


I'll be building on this project and you can see the project here: github link. 

How durable are the excel formulas? 

Always produced the right outputs? 



## Video Graphics

### 

- Before model makes its first response, it reads the instruction files. 
- Instructions tell the model what steps to perform and what the output needs to be. 
- Instructions tell the model where to find useful references or tools
- Instructions tell the model where to find examples. 
- 
