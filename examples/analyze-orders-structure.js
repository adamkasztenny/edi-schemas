const fs = require('fs');

const groupDefinitions = JSON.parse(fs.readFileSync('../edifact/D96A/recordsD96AUN.json', 'utf8'));
const schemaForOrders = JSON.parse(fs.readFileSync('../edifact/D96A/ORDERSD96AUN.json', 'utf8'));

function analyzeSegments(segments, indentation) {
    segments.forEach(segment => {
        const id = segment[0];
        const mandatory = segment[1] == 'M';
        const type = segment[3];

        if (id !== 'BOTSID') {
            if (id[0] === 'C' || id[0] === 'S') {
                console.log(indentation, id, mandatory ? 'mandatory' : 'conditional');
            } else {
                console.log(indentation, id, 'Type: ', type, mandatory ? 'mandatory' : 'conditional');
            }
        }
    });
    console.log('\n');
}

function analyzeGroups(groups, indentation) {
    groups.forEach(group => {
        const id = group['ID'];
        const level = group['LEVEL'];
        const mandatory = group['MIN'] > 0;
        const segments = groupDefinitions[id];

        console.log(indentation, id, mandatory ? 'mandatory' : 'conditional');
        analyzeSegments(segments, '\t' + indentation);

        if (level) {
            analyzeGroups(level, '\t' + indentation);
        }
    });
}

analyzeGroups(schemaForOrders, '');
