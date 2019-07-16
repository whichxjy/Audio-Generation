(
var get_pitch_dict = {
    arg data;
    var pre_idx = 0, curr_idx = 1, next_idx = 2,
        pre_pitch, curr_pitch, next_pitch, pitch_dict = ();

    for (1, data.size - 2, {
        pre_pitch = data[pre_idx];
        curr_pitch = data[curr_idx];
        next_pitch = data[next_idx];

        if (pitch_dict[pre_pitch].isNil, {
            pitch_dict[pre_pitch] = ();
        });

        if (pitch_dict[pre_pitch][curr_pitch].isNil, {
            pitch_dict[pre_pitch][curr_pitch] = List.new(0);
        });

        pitch_dict[pre_pitch][curr_pitch].add(next_pitch);

        pre_idx = curr_idx;
        curr_idx = next_idx;
        next_idx = curr_idx + 1;
    });

    pitch_dict;
};

var generate_audio = {
    arg data, pitch_dict;
    var pre_pitch, curr_pitch, next_pitch, pick_next_pitch;

    pre_pitch = pitch_dict.keys.choose;
    curr_pitch = pitch_dict[pre_pitch].keys.choose;

    pick_next_pitch = {
        next_pitch = pitch_dict[pre_pitch][curr_pitch].choose;
        pre_pitch = curr_pitch;
        curr_pitch = next_pitch;
        next_pitch;
    };

    Pbind(
        \dur, 0.1,
        \dur, Prand([
            Pseq(#[1]),
            Pseq(#[0.5, 0.5]),
            Pseq(#[0.5, 0.5]),
            Pseq(#[0.25, 0.25, 0.25, 0.25]),
            Pseq(#[0.5, 0.25, 0.25]),
            Pseq(#[0.25, 0.25, 0.5]),
            Pseq(#[0.25, 0.5, 0.25])
        ], inf),
        \midinote, Pfunc(pick_next_pitch),
        \pan, 0.6,
        \db, -5,
        \dn, Pwhite(2, 10, inf),
        \degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf)
    ).play;
};

var main = {
    arg pathname;
    var fp, lines, data, pitch_dict;

    postln("Selected path: " + pathname);

    lines = FileReader.read(
        pathname,
        skipEmptyLines: true,
        skipBlanks: true,
        delimiter: 32.asAscii
    );

    data = [];
    lines.do({
        arg line;
        data = data ++ line;
    });

    for (0, data.size - 1, {
        arg i;
        data[i] = data[i].asInteger;
    });

    if (data.size >= 3, {
        pitch_dict = get_pitch_dict.value(data);
        generate_audio.value(data, pitch_dict);
    }, {
        postln("Too little data");
    });
};

var fail_to_select_file = {
    postln("Dialog was cancelled. Try again.");
};

FileDialog(
    main,
    fail_to_select_file,
    fileMode: 1,
    stripResult: true
);
)