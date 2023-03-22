function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'PAPER', 'arseny_learning_photostim_paper');
end
obj = schemaObject;
end
