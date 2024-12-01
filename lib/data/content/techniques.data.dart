import '../models/techniques.mdl.dart';

const techniquesData = [
  TechniquesModel(
    label: 'Beginner',
    title: 'Breaststroke',
    imagePath: 'assets/images/content/techniques/breaststroke.jpg',
    preview:
        'Breaststroke is a swimming style where the swimmer moves on their chest, using symmetrical arm and leg movements that resemble a frog kick.',
    desc: '''
        Body Position: Lie flat on your chest with your body as close to horizontal as possible, but with a slight incline to facilitate breathing.
        Arm Movement: Extend your arms straight in front, then pull them outward and down in a circular motion until they meet back in front of your chest. Make sure your elbows stay high and your hands finish close to each other.
        Leg Kick (Frog Kick): Bend your knees, bringing your heels toward your glutes, then kick your legs outward in a circular motion, bringing your legs back together to push the water behind you.
        Breathing: Lift your head to inhale during the arm pull, then exhale as you return your arms forward.
        Timing: Arm and leg movements should be coordinated, with one stroke of the arms followed by a kick for each cycle.
        ''',
  ),
  TechniquesModel(
    label: 'Intermediate',
    title: 'Freestyle (Crawl)',
    imagePath: 'assets/images/content/techniques/freestyle-crawl.jpg',
    preview:
        'The freestyle, or front crawl, is the fastest swimming stroke, characterized by alternating arm strokes and a flutter kick.',
    desc: '''
        Body Position: Lie on your chest, keeping your body flat, streamlined, and horizontal.
        Arm Stroke: Extend one arm forward while pulling the other arm back beneath your body in a continuous, alternating motion. Each arm should make a full stroke from entry to exit at the hip.
        Leg Kick (Flutter Kick): Keep your legs straight and close together, moving them up and down alternately. The movement should start from the hips, not the knees, for efficiency.
        Breathing: Turn your head to one side for an inhale as your arm on that side exits the water. Alternate sides for balanced breathing if possible.
        Timing: Focus on rhythmic breathing with each arm stroke while maintaining a steady kick.
        ''',
  ),
  TechniquesModel(
    label: 'Intermediate',
    title: 'Backstroke',
    imagePath: 'assets/images/content/techniques/backstroke.jpg',
    preview:
        'The backstroke involves swimming on the back with alternating arm strokes and a flutter kick. It’s one of the easiest strokes for beginners to breathe with, as the face remains above water.',
    desc: '''
        Body Position: Lie flat on your back, looking straight up, and keep your body as horizontal as possible.
        Arm Movement: Reach one arm straight behind your head, then rotate your body slightly as you pull the arm down towards your hip. Alternate arms continuously.
        Leg Kick: Perform a flutter kick with straight legs, with motion starting from the hips.
        Breathing: Breathe continuously and naturally, as your face is out of the water.
        Timing: Keep a steady, alternating rhythm between arms and legs for a smooth glide through the water.
        ''',
  ),
  TechniquesModel(
    label: 'Advanced',
    title: 'Butterfly',
    imagePath: 'assets/images/content/techniques/butterfly.jpg',
    preview:
        'The butterfly stroke is a challenging and powerful stroke where both arms move simultaneously in a circular motion, and the legs perform a dolphin kick.',
    desc: '''
        Body Position: Keep your body flat and close to the surface, with your chest slightly inclined downwards.
        Arm Stroke: Both arms simultaneously move from above the head, sweeping down and out in a wide arc, finishing at the hips. Then, swing them forward again to start a new stroke.
        Dolphin Kick: Keep your legs together and make a simultaneous kicking motion, moving in a wave-like motion from the hips to the feet.
        Breathing: Lift your head to inhale as your arms come out of the water. Exhale as your face returns underwater.
        Timing: Aim for two dolphin kicks per arm stroke — one as your arms pull down, and the second as they come back forward.
        ''',
  ),
  TechniquesModel(
    label: 'Beginner',
    title: 'Sidestroke',
    imagePath: 'assets/images/content/techniques/sidestroke.jpg',
    preview:
        'Sidestroke is a relaxed, energy-efficient swimming style often used in rescue swimming. The swimmer remains on one side, using a scissor kick.',
    desc: '''
        Body Position: Lie on your side, with one arm extended forward and the other resting alongside your body.
        Arm Movement: Use the top arm to pull water toward you in a half-circle, while the lower arm extends and pulls back.
        Scissor Kick: Pull your knees slightly towards your chest, then snap them open in opposite directions, like scissors, for propulsion.
        Breathing: Breathe naturally, as your head remains above water on the side.
        Timing: Match the scissor kick with your arm movements for a smooth glide.
        ''',
  ),
  TechniquesModel(
    label: 'Beginner',
    title: 'Trudgen',
    imagePath: 'assets/images/content/techniques/trudgen.jpg',
    preview:
        'The Trudgen stroke combines the arm motion of freestyle with a scissor kick and is named after John Trudgen.',
    desc: '''
        Body Position: Swim on your side, facing slightly down.
        Arm Movement: Perform an alternating freestyle stroke, where each arm moves in a circular motion above the water.
        Leg Movement: Add a scissor kick after each arm stroke for momentum.
        Breathing: Breathe in sync with your arm movements when your head turns to the side.
        Timing: Time the scissor kick with each arm stroke to keep a consistent rhythm.
        ''',
  ),
  TechniquesModel(
    label: 'Advanced',
    title: 'Elementary Backstroke',
    imagePath: 'assets/images/content/techniques/elementary-backstroke.jpg',
    preview:
        'Elementary backstroke is a basic stroke often taught to beginners, combining a relaxed arm and leg movement.',
    desc: '''
        Body Position: Float on your back, keeping your body flat and face above water.
        Arm Movement: Extend both arms to your sides, then sweep them back towards your hips.
        Leg Movement: Perform a frog kick similar to breaststroke.
        Breathing: Breathe continuously, as your face is above water.
        Timing: Arm and leg movements should be simultaneous and steady for a gentle, relaxed swim.
        ''',
  ),
  TechniquesModel(
    label: 'Intermediate',
    title: 'Combat Side Stroke',
    imagePath: 'assets/images/content/techniques/combat-side-stroke.jpg',
    preview: 'Often used by military swimmers, this stroke conserves energy with a streamlined side position.',
    desc: '''
        Body Position: Lie on your side with one arm extended forward and the other along your body.
        Arm Movement: The forward arm pulls down towards your body while the other arm pushes back in sync.
        Leg Movement: Perform a scissor kick in sync with arm movements.
        Breathing: Breathe naturally, as your face stays above water.
        Timing: Coordinate the scissor kick and arm pull to maintain energy-efficient propulsion.
        ''',
  ),
  TechniquesModel(
    label: 'Intermediate',
    title: 'Dog Paddle',
    imagePath: 'assets/images/content/techniques/dog-paddle.jpg',
    preview: 'Dog paddle is a simple stroke that mimics a dog’s swimming style, often used by beginners.',
    desc: '''
        Body Position: Stay upright in the water with your head above the surface.
        Arm Movement: Paddle with your hands in front of you, making small circular motions.
        Leg Movement: Kick your legs in short, circular motions to stay afloat.
        Breathing: Keep your head above water and breathe naturally.
        Timing: Move arms and legs continuously for a steady float.
        ''',
  ),
  TechniquesModel(
    label: 'Advanced',
    title: 'Sculling',
    imagePath: 'assets/images/content/techniques/sculling.jpg',
    preview: 'Sculling involves using small, controlled hand movements to stay afloat and maneuver in the water.',
    desc: '''
        Body Position: Lie on your back or stay in an upright position.
        Arm Movement: Use a gentle, circular wrist motion with hands to push water.
        Leg Movement: Legs can remain still or perform a flutter kick for balance.
        Breathing: Breathe naturally as you maintain your position.
        Timing: Maintain continuous arm movements to stay in control.
        ''',
  ),
];
