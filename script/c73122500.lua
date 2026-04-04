--低客的黑调
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<1 then return false end
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end

function s.proc(player)
	local opp=1-player
	if Duel.GetFieldGroupCount(opp,LOCATION_DECK,0)==0 then return end
	local types={TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}
	local opt=Duel.SelectOption(player, aux.Stringid(id,3), aux.Stringid(id,4), aux.Stringid(id,5))
	local decl_type=types[opt+1]
	Duel.ConfirmDecktop(opp,1)
	local g=Duel.GetDecktopGroup(opp,1)
	local tc=g:GetFirst()
	local is_match=false
	if decl_type==TYPE_MONSTER and tc:IsType(TYPE_MONSTER) then
		is_match=true
	elseif decl_type==TYPE_SPELL and tc:IsType(TYPE_SPELL) then
		is_match=true
	elseif decl_type==TYPE_TRAP and tc:IsType(TYPE_TRAP) then
		is_match=true
	end
	if is_match then
		if Duel.SelectYesNo(player, aux.Stringid(id,6)) then
			local og=Duel.GetFieldGroup(opp,LOCATION_HAND,0)
			if og:GetCount()>0 then
				Duel.ConfirmCards(player,og)
				local hg=og:Filter(Card.IsAbleToHand,player)
				if hg:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,player,HINTMSG_ATOHAND)
					local sg=hg:Select(player,1,1,nil)
					Duel.SendtoHand(sg,player,REASON_EFFECT)
					Duel.ConfirmCards(opp,sg)
					Duel.ShuffleHand(player)
					Duel.ShuffleHand(opp)
				end
			end
		end
	end
	Duel.ShuffleDeck(opp)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.proc(tp)
	local opt1=false
	local opt2=false
	if Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 then
		opt1=true
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		opt2=true
	end
	if not opt1 and not opt2 then return end
	
	local op
	if opt1 and opt2 then
		op=Duel.SelectOption(1-tp, aux.Stringid(id,1), aux.Stringid(id,2))
	elseif opt1 then
		op=Duel.SelectOption(1-tp, aux.Stringid(id,1))
	else
		op=Duel.SelectOption(1-tp, aux.Stringid(id,2))
	end
	
	if op==0 and opt1 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	else
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			s.proc(1-tp)
		end
	end
end