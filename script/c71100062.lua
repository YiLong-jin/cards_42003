--电子人_氟石
if cyber_fluorite then return end
cyber_fluorite=cyber_fluorite or {}
local all_loc=LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED 
function cyber_fluorite.code_add(sc,tc,tp)
	local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,all_loc,all_loc,nil,tc:GetOriginalCodeRule())
	g=g:Filter(cyber_fluorite.code_filter,nil,tp)
	for oc in aux.Next(g) do 
		oc:RegisterFlagEffect(71100062,0,0,1,tp)
		local e1=Effect.CreateEffect(sc)
		e1:SetDescription(aux.Stringid(71100062,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCondition(cyber_fluorite.code_con)
		e1:SetValue(71100062)
		e1:SetLabel(tp)
		oc:RegisterEffect(e1)
	end
end
function cyber_fluorite.code_filter(c,tp)
	return not (cyber_fluorite.code_check(c,tp) or c:IsOriginalCodeRule(71100062))
end
function cyber_fluorite.code_check(c,tp)
	local la1,la2=c:GetFlagEffectLabel(71100062)
	return (la1 and la1==tp) or (la2 and la2==tp)
end
function cyber_fluorite.code_con(e)
	local c=e:GetHandler()
	local rp=e:GetLabel()
	return c:IsFaceup() and c:IsControler(1-rp)
end