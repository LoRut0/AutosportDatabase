UPDATE plttoteam_on_stage plt
	SET (quali_score, race_score) = (SELECT quali, race FROM temp 
	WHERE plt.pilots_id = temp.pilot_id AND plt.stages_id = temp.stage_id)