function updateModelFrom(model, data) {
    for (var i=0; i<data.length; i++) {
        if (model.count < i) {
            model.append(data[i]);
        } else {
            model.set(i, data[i]);
        }
    }

    while (model.count > data.length) {
        model.remove(model.count-1);
    }
}

function updateModelWith(model, key, value, update) {
    for (var row=0; row<model.count; row++) {
        var current = model.get(row);
        model.setProperty(row, key, update[row][key]);
    }
}

