<?php

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Display a simple web form
    echo '
    <form method="POST" action="">
        <label for="input">Input:</label><br>
        <textarea name="input" id="input" rows=10 cols=50></textarea><br>
        <input type="submit" value="Submit">
    </form>';
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Process the input
    $input = $_POST['input'];

    // Encode the input using yell.bash script
    $encodedScream = shell_exec("bash yell.bash " . escapeshellarg($input));

    // Return the encoded scream as plain text
    header('Content-Type: text/plain');
    echo $encodedScream;
}
