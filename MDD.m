imaqreset();
structImAq = imaqhwinfo;   % Image aquisition structure
cameraName = char(structImAq.InstalledAdaptors(end));
cameraInfo = imaqhwinfo(cameraName);
cameraId = cameraInfo.DeviceInfo.DeviceID(end);
cameraRes = char(cameraInfo.DeviceInfo.SupportedFormats(end));
videoSource = videoinput(cameraName, cameraId, cameraRes);
videoSource.FrameGrabInterval = 0.5;
set(videoSource, 'FramesPerTrigger',Inf);
set(videoSource, 'ReturnedColorspace', 'rgb');
detector = vision.ForegroundDetector(....
           'NumTrainingFrames', 100, ...
           'InitialVariance', 30*30);
blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
shapeInserter = vision.ShapeInserter('BorderColor','White');
videoPlayer = vision.VideoPlayer();
runLoop = true;
numPts = 0;
frameCount = 0;
while runLoop && frameCount < 20 %%Replace with 1 for continuous detection
     frame = getsnapshot(videoSource());
     fgMask = detector(frame);
     bbox   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     videoPlayer(out); 
end