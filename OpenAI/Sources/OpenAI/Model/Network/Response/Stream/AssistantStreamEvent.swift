//
//  AssistantStreamEvent.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 17/12/24.
//

import Foundation

/// A model that helps retrieve an object from an event.
public enum AssistantStreamEvent {
   
   /// Occurs when a new thread is created.
   /// - data is a thread
   case threadCreated
   
   /// Occurs when a new run is created.
   /// - data is a run
   case threadRunCreated
   
   /// Occurs when a run moves to a queued status.
   /// - data is a run
   case threadRunQueued(Run)
   
   /// Occurs when a run moves to an in_progress status.
   /// - data is a run
   case threadRunInProgress(Run)
   
   /// Occurs when a run moves to a requires_action status.
   /// - data is a run
   case threadRunRequiresAction(Run)
   
   /// Occurs when a run is completed.
   /// - data is a run
   case threadRunCompleted(Run)
   
   /// Occurs when a run fails.
   /// - data is a run
   case threadRunFailed(Run)
   
   /// Occurs when a run moves to a cancelling status.
   /// - data is a run
   case threadRunCancelling(Run)
   
   /// Occurs when a run is cancelled.
   /// - data is a run
   case threadRunCancelled(Run)
   
   /// Occurs when a run expires.
   /// - data is a run
   case threadRunExpired(Run)
   
   /// Occurs when a run step is created.
   /// - data is a run step
   case threadRunStepCreated
   
   /// Occurs when a run step moves to an in_progress state.
   /// - data is a run step
   case threadRunStepInProgress
   
   /// Occurs when parts of a run step are being streamed.
   /// - data is a run step delta
   case threadRunStepDelta(RunStepDelta)
   
   /// Occurs when a run step is completed.
   /// - data is a run step
   case threadRunStepCompleted
   
   /// Occurs when a run step fails.
   /// - data is a run step
   case threadRunStepFailed
   
   /// Occurs when a run step is cancelled.
   /// - data is a run step
   case threadRunStepCancelled
   
   /// Occurs when a run step expires.
   /// - data is a run step
   case threadRunStepExpired
   
   /// Occurs when a message is created.
   /// - data is a message
   case threadMessageCreated
   
   /// Occurs when a message moves to an in_progress state.
   /// - data is a message
   case threadMessageInProgress
   
   /// Occurs when parts of a message are being streamed.
   /// - data is a message delta
   case threadMessageDelta(MessageDelta)
   
   /// Occurs when a message is completed.
   /// - data is a message
   case threadMessageCompleted
   
   /// Occurs when a message ends before it is completed.
   /// - data is a message
   case threadMessageIncomplete
   
   /// Occurs when an error occurs. This can happen due to an internal server error or a timeout.
   /// - data is an error
   case error
   
   /// Occurs when a stream ends.
   /// - data is [DONE]
   case done

}
