import cv2
import numpy as np

# https://stackoverflow.com/questions/33926000/frame-difference-using-python


def main():
    cap = cv2.VideoCapture(
        '/Users/christylee/desktop/iw/videos/lockedOutOfHeaven.mov')
    ret, current_frame = cap.read()
    previous_frame = current_frame

    frameCount = 0
    m_norm_sum = 0

    print(current_frame.size)

    while(cap.isOpened() and current_frame is not None):

        frame_diff = cv2.absdiff(current_frame, previous_frame)
        m_norm = np.sum(abs(frame_diff))  # Manhattan norm
        frameCount += 1
        print(frameCount)
        m_norm_sum += m_norm

        previous_frame = current_frame.copy()
        ret, current_frame = cap.read()

    print(frameCount, m_norm_sum / frameCount)
    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
