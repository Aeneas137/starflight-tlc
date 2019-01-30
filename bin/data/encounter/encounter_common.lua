--[[
	  COMMON FUNCTIONS SHARED BY ALL ENCOUNTER SCRIPTS
--]]


math.randomseed( os.time() )

function distance(x1,y1,x2,y2)
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function target_angle(x1,y1,x2,y2)
	deltaX = x2-x1
	deltaY = y2-y1
	return math.atan2( deltaY, deltaX )
end

------------------------------------------------------------------------
-- RANDOM NUMBER FUNCTION ----------------------------------------------
------------------------------------------------------------------------
function round(num, places)
	local mult = 10^(places or 0)
	return math.floor(num * mult + 0.5) / mult
end

function gen_random(max)
	local temp = math.mod((42 * math.random() + 29573), 139968)
	local ret = math.mod( ((100 * temp)/139968) * 1000000, max)
	return round(ret + 0.5)
end

------------------------------------------------------------------------
-- Update Player's posture in script: ----------------------------------
------------------------------------------------------------------------
function UpdatePosture()
	local nt, maxn

	if POSTURE ~= orig_posture then
		maxn= table.maxn(greetings)
		for nt= 1, maxn do
			table.remove(greetings)
		end
		maxn= table.maxn(statements)
		for nt= 1, maxn do
			table.remove(statements)
		end

		if POSTURE == "obsequious" then
			ObsequiousDialogue()
		elseif POSTURE == "hostile" then
			HostileDialogue()
		else
			FriendlyDialogue()
		end
		orig_posture= POSTURE
	end
end

------------------------------------------------------------------------
-- GET A RANDOM GREETING -----------------------------------------------
------------------------------------------------------------------------
function Greeting()
	local size = table.getn(greetings)
	local n = gen_random(size)
	ACTION = greetings[n].action
	GREETING = greetings[n].player

	if (greetings[n].ftest) then
		FTEST= greetings[n].ftest
	else
		FTEST= 0
	end
	L_Debug("Encounter: calling commFxn(GREETING, " .. tostring(n) .. ", " .. tostring(FTEST) .. ")")
	commFxn(0, n, FTEST)

	--Increment the action counter to determine when the alien is tired of responding
	number_of_actions = number_of_actions + 1

	--choose one of multiple responses
	size = table.getn(greetings[n].alien) --get table size
	local r = gen_random(size)			--choose one at random
	RESPONSE = greetings[n].alien[r]
end

------------------------------------------------------------------------
-- GET A RANDOM STATEMENT ----------------------------------------------
------------------------------------------------------------------------
function Statement()
	local size = table.getn(statements)
	--local size = table.maxn(statements)
	local n = gen_random(size)
	ACTION = statements[n].action
	STATEMENT = statements[n].player

	if (statements[n].ftest) then
		FTEST= statements[n].ftest
	else
		FTEST= 0
	end

	--Increment the action counter to determine when the alien is tired of responding
	number_of_actions = number_of_actions + 1

	L_Debug("Encounter: calling commFxn(STATEMENT, " .. tostring(n) .. ", " .. tostring(FTEST) .. ")")
	commFxn(1, n, FTEST)

	--choose one of multiple responses
	size = table.getn(statements[n].alien)	--get table size
	local r = gen_random(size)				--choose one at random
	RESPONSE = statements[n].alien[r]
end

------------------------------------------------------------------------
-- GET NEXT QUESTION ---------------------------------------------------
------------------------------------------------------------------------
function Question()
	--go to next question (was just clicked on in communication dialogue)
	current_question = next_question

	--get current action
	ACTION = questions[current_question].action

	if (questions[current_question].ftest) then
		FTEST= questions[current_question].ftest
	else
		FTEST= 0
	end
	L_Debug("Encounter: calling commFxn(QUESTION, " .. tostring(current_question) .. ", " .. tostring(FTEST) .. ")")
	commFxn(2, current_question, FTEST)

	--branching action
	if ACTION == "branch" then

		--total number of choices in this branch
		CHOICES = table.getn(questions[current_question].choices)

		Q = {}
		G = {}
		--question globals (for display in game)
		if CHOICES > 0 then
			if (questions[current_question].choices[1].title) then --long branch
				QUESTION1_TITLE= questions[current_question].choices[1].title
			else
				QUESTION1_TITLE= questions[current_question].choices[1].text
			end
			QUESTION1 = questions[current_question].choices[1].text
			Q[1] = QUESTION1
			GOTO1 = questions[current_question].choices[1].goto
			G[1] = GOTO1
		end

		if CHOICES > 1 then
			if (questions[current_question].choices[2].title) then --long branch
				QUESTION2_TITLE= questions[current_question].choices[2].title
			else
				QUESTION2_TITLE= questions[current_question].choices[2].text
			end
			QUESTION2 = questions[current_question].choices[2].text
			Q[2] = QUESTION2
			GOTO2 = questions[current_question].choices[2].goto
			G[2] = GOTO2
		end

		if CHOICES > 2 then
			if (questions[current_question].choices[3].title) then --long branch
				QUESTION3_TITLE= questions[current_question].choices[3].title
			else
				QUESTION3_TITLE= questions[current_question].choices[3].text
			end
			QUESTION3 = questions[current_question].choices[3].text
			Q[3] = QUESTION3
			GOTO3 = questions[current_question].choices[3].goto
			G[3] = GOTO3
		end

		if CHOICES > 3 then
			if (questions[current_question].choices[4].title) then --long branch
				QUESTION4_TITLE= questions[current_question].choices[4].title
			else
				QUESTION4_TITLE= questions[current_question].choices[4].text
			end
			QUESTION4 = questions[current_question].choices[4].text
			Q[4] = QUESTION4
			GOTO4 = questions[current_question].choices[4].goto
			G[4] = GOTO4
		end

		if CHOICES > 4 then
			if (questions[current_question].choices[5].title) then --long branch
				QUESTION5_TITLE= questions[current_question].choices[5].title
			else
				QUESTION5_TITLE= questions[current_question].choices[5].text
			end
			QUESTION5 = questions[current_question].choices[5].text
			Q[5] = QUESTION5
			GOTO5 = questions[current_question].choices[5].goto
			G[5] = GOTO5
		end

		return

	elseif ACTION == "restart" then
		next_question = first_question

	elseif ACTION == "terminate" or ACTION == "attack" then
		return

	elseif ACTION == "jump" and goto_question == 0 then
		next_question = questions[current_question].goto

	--Increment the action counter to determine when the alien is tired of responding
	 	number_of_actions = number_of_actions + 1

	--goto_question overrides the normal jump action
	elseif ACTION == "jump" and goto_question > 0 then
		next_question = goto_question
		goto_question = 0
	end

	if (questions[current_question].title) then --long question
		QUESTION_TITLE= questions[current_question].title
	else
		QUESTION_TITLE= questions[current_question].player
	end
	--actions other than terminate or attack needs question/response
	--QUESTION = questions[current_question].player
	QUESTION= joinFragments(2, current_question)

	--choose one of multiple responses
	local size = table.getn(questions[current_question].alien)	--get table size
	local r = gen_random(size)									--choose one at random
	RESPONSE = questions[current_question].alien[r]
end

------------------------------------------------------------------------
-- BRANCH TO NEW SEQUENCE ----------------------------------------------
------------------------------------------------------------------------
-- C++ code sets global CHOICE based on user's branch choice
-- G{} is table of gotos retrieved from questions{} for the branch action
function Branch()
	next_question = G[CHOICE]
end

------------------------------------------------------------------------
-- TEST SCRIPT ---------------------------------------------------------
------------------------------------------------------------------------
function TestScript()
	print("\nINITIALIZING...")
	if ACTION == "terminate" or ACTION == "attack" then print(RESPONSE) return end

	print("\nGREETINGS")
	for n = 1, 5 do
	  Greeting()
	  print(GREETING)
	  print(RESPONSE)

	  --comment out for production
	  if ACTION == "terminate" then print("COMM TERMINATED!") end
	  if ACTION == "attack" then print("ALIEN IS ATTACKING!") end
	end

	print("\nSTATEMENTS")
	for n = 1, 5 do
	  Statement()
	  print(STATEMENT)
	  print(RESPONSE)

	  --comment out for production
	  if ACTION == "terminate" then print("COMM TERMINATED!") end
	  if ACTION == "attack" then print("ALIEN IS ATTACKING!") end
	end

	print("\nQUESTIONS");
	for n = 1, 6 do
		Question()

		if ACTION == "branch" then
			print("BRANCH")
			for n = 1,CHOICES do
				print(" " .. n .. ": " .. Q[n] .. " (" .. G[n] .. ")" )
			end

			next_question = GOTO1
			print("  <Following " .. Q[1] .. " thread>")

		else

			print(current_question .. ": " .. QUESTION)
			print(RESPONSE)
		end

		--comment out for production
		if ACTION == "terminate" then print("COMM TERMINATED!") end
		if ACTION == "attack" then print("ALIEN IS ATTACKING!") end
	end
end

function joinFragments(ctype, n)
	local t, playerFragment, fragmentTable, veto, fragmentVeto, vetoed
	local temp, tSize, choice, i, commentEnd

	if (ctype == 0) then							--greeting
		t= greetings[n]
	elseif (ctype == 1) then						--statement
		t= statements[n]
	else
		t= questions[n]
	end

	if ((t.noJoinFragments) or (t.nojoin) or (t.noJoin)) then 			--vetos
		return t.player
	elseif ((not t.playerFragment) and (not t.playerfragment)) then
		return t.player
	end

	if (t.playerFragment) then
		playerFragment= t.playerFragment
	else
		playerFragment= t.playerfragment
	end

	if (t.fragmentTable) then
		fragmentTable= t.fragmentTable
	elseif (t.fragmenttable) then
		fragmentTable= t.fragmenttable
	else
		fragmentTable= preQuestion.info
	end


	commentEnd= "."
	if (POSTURE == "obsequious") then
		fragmentTable= fragmentTable.obsequious
		if (ctype == 2) then
			commentEnd= "."
		end
	elseif (POSTURE == "friendly") then
		fragmentTable= fragmentTable.friendly
		if (ctype == 1) then
			commentEnd= "?"
		end
		if (ctype == 3) then
			commentEnd= "?"
		end
		if (ctype == 5) then
			commentEnd= "?"
		end
	else
		fragmentTable= fragmentTable.hostile
	end


	if (t.fragmentVeto) then
		veto= true
		fragmentVeto= t.fragmentVeto
	elseif (t.fragmentveto) then
		veto= true
		fragmentVeto= t.fragmentveto
	else
		veto= false
	end

	if (veto) then
		if (POSTURE == "obsequious") then
			fragmentVeto= fragmentVeto.o
		elseif (POSTURE == "friendly") then
			fragmentVeto= fragmentVeto.f
		else
			fragmentVeto= fragmentVeto.h
		end
	end

	--If all fragments have been (mistakenly) vetoed, use the player field.
	if (veto) then
		if (table.getn(fragmentTable) == table.getn(fragmentVeto)) then
			return t.player
		end
	end

	if (t.introFragment) then
		temp= t.introFragment .. " "
	elseif (t.introfragment) then
		temp= t.introfragment .. " "
	else
		temp= ""
	end

	repeat
		tSize= table.getn(fragmentTable)
		choice= gen_random(tSize)
		vetoed= false
		if (veto) then
			for i= 1, table.getn(fragmentVeto) do
				if (fragmentVeto[i] == choice) then
					vetoed= true
				end
			end
		end
	until (not vetoed)

	temp= temp .. fragmentTable[choice] .. " " .. playerFragment .. commentEnd
	return temp
end
