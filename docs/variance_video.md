
**Video 2: The AI tool that does an hour of trial balance variance review in two minutes**

---

[Cold open. On camera. Tight shot.]

Every auditor or accountant has done this. You've got a prior year's trial balance. You've got this year's trial balance. Somebody needs an explanation for what changed and why. So you open Excel, line up the accounts, add some formulas, eyeball the differences, write up the ones that matter, and investigate why or send questions to someone else for them to answer. 

It's simple, but tedious work. It's also necessary work, and most of us have spent Friday afternoons doing it at the beginning of a project.

A few weeks ago I built a tool that does the first pass on this in about two minutes.

Actually, it's not really a tool. It's a system of instructions that utilizes coding agents like OpenAI's codex or Claude Code or the Hermes agent and it provides the workflow steps and output requirements I need for this task. 

I'll show you exactly how it works, because this kind of approach can be used for any kind of work that you might want to use with an AI model. 

[Brief pause.]

But before the demo I want to spend three minutes on something that explains *why* this tool works the way it does. Because the obvious question is — why didn't you just paste the trial balances into ChatGPT and ask the same question? And the answer to that is most of what this whole channel is about.

[Cut to: clean title card with channel name. Hold 2 seconds. Back to camera.]

## The setup — models vs. harnesses

[On camera, then cut to the models-vs-harnesses diagram as you talk through it. Build it up progressively if you can — left side first, then right side.]

When most people think about using AI for work, they're picturing the chatbot they met in 2022. A text box, a chat scroll, you type something, you get a response. That picture is the thing you have to let go of.

Here's a more useful way to think about it.

[Diagram appears — left side only, the chatbot panel.]

What you're using when you open ChatGPT or Claude or any of those is a *model* — the large language model itself — wrapped in a very thin layer. A chat window. That's the whole harness. You can type, you can paste, you can read what comes back. That's it.

The model can only do what you can fit through the text box. It doesn't see your files. It doesn't remember the last project you worked on. It can't save its work anywhere you can come back to. And critically for our line of work — you can't rerun the same conversation and get the same result.

[Right side of diagram appears.]

What I'm going to show you is the same model — the *exact* same model — with a different harness around it. Instead of a chat window, it's a folder on my computer. Inside that folder are a few instruction files telling the model how to do the work, the actual trial balance files I want it to analyze, a specification for what the output should look like, and a place for it to save its results.

Same model. Different setup. Different results.

[Pause. Direct to camera.]

The model didn't get smarter. We stopped using it through a soda straw.

[Beat.]

This matters for two reasons. One — and this is the practical one — the output is dramatically better when the model has your actual files and clear rules instead of a paragraph of you describing what you want. That's a phrase I'm going to keep coming back to on this channel: *bring your data to the model.* Don't summarize your data and hope. Put the files in the room.

The second reason is reproducibility. If a regulator or a partner asks me later how I got this output, I can show them the exact instructions, the exact input files, and rerun the analysis from scratch. You can't do that with a chat session. And for audit work, that's not a nice-to-have. It's the whole job.

[On camera, slight smile.]

There's one more thing worth saying about this approach before the demo. It also means the model is *interchangeable.* When a better one comes out next quarter — and one will — I don't redesign my workflow. I change one setting and rerun the same instructions against the new model. The workflow lives in my folder. The model is the part I can swap.

Okay. Let's look at the tool.

---

## The demo

[Cut to screen recording. First shot: the project folder, clean view of the file structure.]

Here's the whole project. A handful of files — 

Here's the inbox folder with our trial balance task included as a text file. 

Here's the SKILL.md file, which is the instructions document. 

[Progress chyron appears at the bottom of the screen: *Load TBs → Run analysis → Review output → Document findings*. Step one highlighted.]

The inbox folder is just two trial balances. This is fake data but it includes over 300 accounts in each file.  It has the real shape of a trial balance with the made-up names. Same client, prior year and current year. And there are a few accounts that exist in one year and not the other. This is what real TBs look like when they show up on your desk.

The request file just a text file, request.md. It directs the model to where the source data is located in the project, what thresholds to use for follow-up questions, and what skills (or tasks) need to be performed on the data. What you'll notice in here is that this is written almost just like you might write an email to a team member who will complete the work.

[Show the two TBs side by side briefly.]

Next, I'll just open up codex app, tell it to process the request file and watch it work. 

[Run the tool. Show terminal output briefly, then the output report.]

Five minutes. Here's the output.

[Walk through the report on screen.]

First, it includes both source files, exactly as they were included in the source file. 

Next, it includes our comparison tabs with the account numbers, account names, and formulas for each year that use the account number in the SUMIF formula to get each year's total.  For each one — a SUMIF formula to obtain the prior year amount for each account, the current year amount, the variance in dollars and percent, and a draft explanation written from the model's read of the account name and context. It also ranked the list of accounts by material change.

Plus a Summary tab describing the steps, a summary of the results, 

[Progress chyron: step three highlighted.]

This is where the review work starts. And this is the part I want to spend real time on, because it's the part most AI demos skip.

[Pause. Slower.]

Let me show you three things the tool got wrong, or at least handled in a way that needs a human to catch.

[Zoom into specific items in the report.]

First — this account here. The model flagged a 40 percent increase and wrote an explanation that sounds plausible. It said it looks like increased headcount based on the account name. But I happen to know this client had a one-time accrual reversal in the prior year that made the base artificially low. The model couldn't know that. It has no memory of the prior audit. So the variance is correctly identified, but the *explanation* is wrong, and a junior auditor reading this output without context would copy that explanation straight into the workpaper.

Second — this one. The model didn't flag it at all. The dollar variance is small but it's a related-party account, which means even small changes deserve attention. The tool ranked it by dollar magnitude and buried it. That's a configuration choice on my end — I could tell it to always surface related-party accounts regardless of size — but it didn't do that on its own.

Third — the rename detection. It correctly identified the office supplies rename. But it also incorrectly merged two accounts that have similar names but are different things. The model saw the similar names and assumed a rename. A human looking at the chart of accounts would catch it because the account numbers tell you they're different. The model has the data, it just made a judgment call I disagree with.

[Back on camera.]

So what is this tool, actually? It's a first pass. It's the work a staff auditor would do in their first hour on the engagement. It does that work in two minutes and it does it consistently. Every TB gets the same checks, the same format, the same level of detail.

[Progress chyron: step four highlighted. A simple two-column visual appears — "What the tool does" / "What I still do."]

What the tool does — pulls the trial balances, normalizes them, identifies structural changes, ranks variances, drafts explanations, formats the output.

What I still do — apply context the model doesn't have, override rankings where audit judgment requires it, validate the rename and split detections, write the final explanations, and put my name on the workpaper.

[Direct to camera.]

That last part isn't going anywhere. The model can't sign the workpaper. I can. That means I'm still responsible for what's in it, which means I still read every line. The tool changed how I spend my Friday afternoon. It didn't change what I'm accountable for.

---

## Close

[On camera.]

The full code is on GitHub. Link in the description. Take it, fork it, point it at your own TBs. It's a small project and it's meant to be read, not just used.

If you want to see this approach pushed further, next week I'm going to show you an agent built almost entirely out of instruction files — no orchestration code at all — that does data reliability checks on any dataset you throw at it. Same idea as this video, taken further.

Subscribe if you want to see it. And if you're an auditor, accountant, or program manager and any of this resonated, leave a comment with the workflow you'd most want to see this approach applied to next. I read everything.

[Cut.]

---

A few notes on the script:

The intro runs about 3 minutes, which is the upper bound of what's safe before a demo. I think it earns its length because the models-vs-harnesses point sets up the whole channel, not just this video. If you watch the rough cut and it drags, the easiest cut is the second reason (reproducibility) — fold it into one sentence inside the first reason. The first reason (bring your data to the model) is non-negotiable for this video.

The "soda straw" line is in there because the diagram has it. If you decided to cut that footer from the diagram, change this line in the script to something like "Same model. Different setup. Different results."

The three failure modes in the demo are the most important part of the video. Don't compress them. Each one teaches the audience something different — context the model can't have, configuration choices the human owns, and judgment calls the human should override. Those three categories cover almost every "where AI still needs a human" conversation. You're building a vocabulary the audience can reuse.

The "what the tool does / what I still do" visual is the brand moment. Linger on it. That's the frame that makes a senior auditor watching trust you.

The article and video pairing is doing real work — the article has the "third option" frame and the model-interchangeability argument in more depth, and the video can drop a single line about it and link out. That's the right division of labor. Don't try to cram the full article argument into the video.

One thing I deliberately didn't write into the script: a measured time-saved claim. You say "two minutes" for the tool runtime, which is observable, and "an hour" in the cold open as the rough manual baseline, which is fair as colloquial framing. If you want to make a stronger claim later — like "this saves me 45 minutes per engagement on average" — measure it across a few real runs first. The house rule earns its keep here.

Want me to draft the YouTube description and the LinkedIn cross-post, or work on the script for video 3 next?