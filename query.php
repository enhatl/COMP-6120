<?php
include 'database.php';
$con = getConnection();
if(!$con) {
    reportError(mysqli_error($con));
    die();
}
$tables = array('Book', 'Customer', 'Order_Detail', 'Orders', 'Shipper', 'Subject', 'Supplier');

function reportError($msg) {
    echo '<div style="width: 100%; background: #f2dede; padding: 10px; border-radius: 5px">' . $msg . '</div>';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>COMP 6120 Term Project</title>
    <link rel='stylesheet' href='style.css' type='text/css' media='all' />
</head>

<body>
    <div style="text-align: center; padding: 10px; background: lightyellow">
        <h2 style="margin-bottom: 0;">COMP 6120 Term Project</h2><h3>Emily Hollingshead</h3>
    </div>

    <div style=" margin-top: 20px;width: 300px;margin-left: auto;margin-right: auto; text-align: center;">
        <a href="index.php" style="border-radius: 5px; background: lightblue; width: 100px; height: 25px; padding: 10px;">All Tables</a>
        <a href="query.php" style="border-radius: 5px; background: lightblue; width: 100px; height: 25px; padding: 10px;">Query Database</a>
    </div>


<h1>Query Database</h1>
<div style="margin: 5px">
    <form method="POST" action="query.php">
        <textarea name="query" style="font-family: consolas; font-size: larger; width: 100%; height: 150px; border: 1px solid gainsboro; padding: 5px"><?= stripslashes($_POST['query'])?></textarea>
        <br />
        <input type="submit"/>
    </form>
</div>

<div style="padding: 5px">

<?php
if(isset($_POST['query'])) {
    $query = $_POST['query'];
    $query = stripcslashes($query);
    $q = strtolower($query);
    $forbidden = array('drop', 'delete', 'update', 'create', 'alter');
    foreach($forbidden as $key) {
        if(strpos($q, $key) !== false) {
            reportError("Query modifies the data! Queries like DROP, DELETE, UPDATE, CREATE and ALTER are not supported as they change the underlying data.");
            die();
        }
    }



    $result = executeQuery($con, $query);
    if($result == false) {
        reportError(mysqli_error($con));
        die();
    }

    ?>
    <table class="bordered">
        <thead>
        <?php
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
<?php
}
?>
</div>

</body>
</html>
<?php mysqli_close($con); ?>
