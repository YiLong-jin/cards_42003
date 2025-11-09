--太古传说【石板】 2025/11/01 02:52:30 scripted by 翼龙
local this,id,ofs=GetID()
this.rtsj_Ancient_Legends=true
function this.initial_effect(c)
	aux.AddCodeList(c,71000202)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(this.tg)
	e1:SetOperation(this.op)
	c:RegisterEffect(e1)
end
function this.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function this.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local sg=g:Select(tp,1,#g,nil)
	Duel.ConfirmCards(1-tp,sg)
	if c:IsRelateToEffect(e) then sg:RemoveCard(c) end 
	local spg=Group.CreateGroup()
	local dr=false
	local th=false
	for tc in aux.Next(sg) do
		if tc:IsCode(71000202) and tc:IsCanBeSpecialSummoned(e,0,tp,false,true) then
			spg:AddCard(tc)
		end
		if tc.rtsj_Ancient_Legends then
			dr=true
		end
		if aux.IsCodeListed(tc,71000202) then
			th=true
		end
	end
	if #spg>0 and (#spg==1 or (not Duel.IsPlayerAffectedByEffect(tp,59822133))) then
		Duel.SpecialSummon(spg,0,tp,tp,false,true,POS_FACEUP)
	end
	if dr then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if th then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,function(c) return aux.IsCodeListed(c,71000202) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
