<?php
include 'database.php';
$con = getConnection();
$tables = array('Book', 'Customer', 'Employee', 'OrderDetail', 'Orders', 'Shipper', 'Subject', 'Supplier');
?>

<!DOCTYPE html>
<html>
<head>
    <title>COMP 6120 Term Project</title>
    <link rel='stylesheet' href='style.css' type='text/css' media='all' />
</head>

<body>
    <div style="text-align: center; padding: 10px; background: lightyellow">
        <h2 style=" margin-bottom: 0;">COMP 6120 Term Project</h2><h3>Emily Hollingshead </h3>
    </div>


      <div style="
        margin-top: 20px;
        width: 300px;
        margin-left: auto;
        margin-right: auto;
        text-align: center;">
            <a href="index.php" style="border-radius: 5px; background: lightblue; width: 100px; height: 25px; padding: 10px;">All Tables</a>
          <a href="query.php" style="border-radius: 5px; background: lightblue; width: 100px; height: 25px; padding: 10px;">Query Database</a>
    </div>



<h1>All Tables</h1>
<?php
foreach($tables as $tableName) { ?>
    <h2><?= $tableName ?> </h2>
    <table class="bordered">
        <thead>
        <?php
        $query = 'SELECT * FROM '. $tableName;
        $result = executeQuery($con, $query);
        if(!$result) {
            die('Query failed to execute: ' . mysqli_error($con));
        }
        //$books = mysqli_fetch_assoc($result);
        $numFields = mysqli_num_fields($result);

        echo '<tr>';
        for($i = 0; $i < $numFields; $i++) {
            $field = mysqli_fetch_field_direct($result, $i);
            echo '<th>' . $field->name . '</th>';
        }
        echo '</tr>';


        ?>
        </thead>

        <?php
        $rows = array();
        while($resultRow = mysqli_fetch_assoc($result)) {
            $rows[] = $resultRow;
        }
        foreach($rows as $row) {
            echo '<tr>';
            foreach($row as $col) {
                echo '<td>' . $col . '</td>';
            }
            echo '</tr>';
        }

        mysqli_free_result($result);

        ?>

    </table>

    <br><br>
<?php
}
?>
</body>
</html>
<?php mysqli_close($con); ?>
