import {
  useLangGraphInterruptState,
  useLangGraphSendCommand,
} from "@assistant-ui/react-langgraph";
import { Button } from "./ui/button";

export const InterruptUI = () => {
  const interrupt = useLangGraphInterruptState();
  const sendCommand = useLangGraphSendCommand();
  if (!interrupt) return null;

  const respondYes = () => {
    sendCommand({ resume: "yes" });
  };
  const respondNo = () => {
    sendCommand({ resume: "no" });
  };

  return (
    <div className="flex flex-col gap-2">
      <div>Interrupt: {interrupt.value}</div>
      <div className="flex items-end gap-2">
        <Button onClick={respondYes}>Confirm</Button>
        <Button onClick={respondNo}>Reject</Button>
      </div>
    </div>
  );
};
