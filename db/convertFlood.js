db.flooddata_staging.find().forEach(function(obj){
        obj.Time = ISODate(obj.Time);
        delete obj['_id'];
        delete obj[''];
        var station = db.stations.findOne({stationReference:obj.stationReference});
        if(station){
                obj.coordActual = station.coordActual;
                obj.WiskiRiverName = station.WiskiRiverName;
        }else{
                obj.coordActual = [0,0];
                obj.WiskiRiverName = "";
        }
        db.flooddata.insert(obj);
});
