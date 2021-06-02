
class MyCamera
{
    PApplet mainWindow;
    Capture cam;

    MyCamera(PApplet _main)
    {
        mainWindow = _main;
    }


    boolean cameraInitial()
    {
        String[] cameras = Capture.list();

        if (cameras == null) {
            println("Failed to retrieve the list of available cameras, will try the default...");
            cam = new Capture(mainWindow, 640, 480);
            return false;
        }
        
        else if (cameras.length == 0) 
        {
            println("There are no cameras available for capture.");
            exit();
            return false;

        }


        else {
            println("Available cameras:");
            printArray(cameras);

            //特殊情况
            //这个摄像头不能用
            if(cameras[0] == "[0]\"Link to MyASUS-Shared Cam\"")
            {
                println("相机不可用，tryagain");

            }

            // The camera can be initialized directly using an element
            // from the array returned by list():
            cam = new Capture(mainWindow, cameras[0]);
            // Or, the settings can be defined based on the text in the list
            //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
            
            // Start capturing the images from the camera
            cam.start();
            return true;
        }
    }
}




