const fs = require('fs');

const groupDefinitions = JSON.parse(fs.readFileSync('../x12/4010/records004010.json', 'utf8'));
const schemaFor850 = JSON.parse(fs.readFileSync('../x12/4010/850004010.json', 'utf8'));

function analyzeSegments(segments, indentation) {
    segments.forEach(segment => {
        const id = segment[0];
        const mandatory = segment[1] === 'M';
        const type = segment[3];

        if (id !== 'BOTSID') {
            console.log(indentation, id, 'Type: ', type, mandatory ? 'mandatory' : 'conditional');
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

analyzeGroups(schemaFor850, '');
