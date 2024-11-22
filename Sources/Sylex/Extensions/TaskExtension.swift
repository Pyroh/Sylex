//
//  TaskExtension.swift
//  Sylex
//
//  MIT License
//
//  Copyright (c) 2024 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// A frozen struct representing a task timeout error.
@frozen public struct TaskTimeoutError: Error {
    /// Initializes a new TaskTimeoutError instance.
    init() { }
}

public extension Task where Success == Void, Failure == Never {
    /// Waits for the task to complete.
    ///
    /// This method suspends the current task until this task completes.
    ///
    /// - Note: This method is marked as `@inlinable`, which means the compiler may inline its implementation at the call site.
    @inlinable
    func wait() async { await self.value }
    
    /// Waits for the task to complete and checks for cancellation.
    ///
    /// This method suspends the current task until this task completes,
    /// while also setting up a cancellation handler to cancel this task
    /// if the current task is cancelled.
    @inlinable
    func waitAndCheckCancellation() async {
        await withTaskCancellationHandler {
            await self.value
        } onCancel: {
            self.cancel()
        }
    }
}

public extension Task where Success == Void, Failure: Error {
    /// Waits for the task to complete, potentially throwing an error.
    ///
    /// This method suspends the current task until this task completes or throws an error.
    ///
    /// - Throws: The error thrown by the task, if any.
    @inlinable
    func wait() async throws { try await self.value }
    
    /// Waits for the task to complete and checks for cancellation, potentially throwing an error.
    ///
    /// This method suspends the current task until this task completes or throws an error,
    /// while also setting up a cancellation handler to cancel this task
    /// if the current task is cancelled.
    ///
    /// - Throws: The error thrown by the task, if any, or a `CancellationError` if the task is cancelled.
    @inlinable
    func waitAndCheckCancellation() async throws {
        try await withTaskCancellationHandler {
            try await self.value
        } onCancel: {
            self.cancel()
        }
    }
}

public extension Task where Success == Void, Failure == Error {
    /// Creates a new task that repeatedly performs the given operations at the specified interval.
    ///
    /// - Parameters:
    ///   - duration: The time interval between each execution of the operations.
    ///   - tolerance: The allowed tolerance in scheduling the operations. Defaults to `nil`.
    ///   - clock: The clock to use for measuring time. Defaults to `ContinuousClock()`.
    ///   - priority: The priority of the created task. Defaults to `nil`.
    ///   - flag: Whether to execute the operations immediately before starting the interval. Defaults to `false`.
    ///   - operations: The closure containing the operations to perform.
    /// - Returns: The created task.
    @discardableResult @inlinable
    static func every<C: Clock>(_ duration: C.Instant.Duration,
                                tolerance: C.Instant.Duration? = nil,
                                clock: C = ContinuousClock(),
                                priority: TaskPriority? = nil,
                                fireFirst flag: Bool = false,
                                @_inheritActorContext @_implicitSelfCapture
                                operations: @Sendable @escaping @isolated(any) () async -> Success) -> Self {
        Task(priority: priority) {
            if flag { await operations() }
            try await withRecurrence(duration, tolerance: tolerance, clock: clock, body: operations)
        }
    }
    
    /// Creates a new task that repeatedly performs the given throwing operations at the specified interval.
    ///
    /// - Parameters:
    ///   - duration: The time interval between each execution of the operations.
    ///   - tolerance: The allowed tolerance in scheduling the operations. Defaults to `nil`.
    ///   - clock: The clock to use for measuring time. Defaults to `ContinuousClock()`.
    ///   - priority: The priority of the created task. Defaults to `nil`.
    ///   - flag: Whether to execute the operations immediately before starting the interval. Defaults to `false`.
    ///   - operations: The closure containing the throwing operations to perform.
    /// - Returns: The created task.
    @discardableResult @inlinable
    static func every<C: Clock>(_ duration: C.Instant.Duration,
                                tolerance: C.Instant.Duration? = nil,
                                clock: C = ContinuousClock(),
                                priority: TaskPriority? = nil,
                                fireFirst flag: Bool = false,
                                @_inheritActorContext @_implicitSelfCapture
                                operations: @Sendable @escaping @isolated(any) () async throws -> Success) -> Self {
        Task(priority: priority) {
            if flag { try await operations() }
            try await withRecurrence(duration, tolerance: tolerance, clock: clock, body: operations)
        }
    }
    
    /// Creates a new task that performs the given operations after a specified delay.
    ///
    /// - Parameters:
    ///   - duration: The time to wait before executing the operations.
    ///   - tolerance: The allowed tolerance in scheduling the operations. Defaults to `nil`.
    ///   - clock: The clock to use for measuring time. Defaults to `ContinuousClock()`.
    ///   - priority: The priority of the created task. Defaults to `nil`.
    ///   - flag: Whether to execute the operations immediately before starting the delay. Defaults to `false`.
    ///   - operations: The closure containing the operations to perform.
    /// - Returns: The created task.
    @discardableResult @inlinable
    static func delay<C: Clock>(_ duration: C.Instant.Duration,
                                tolerance: C.Instant.Duration? = nil,
                                clock: C = ContinuousClock(),
                                priority: TaskPriority? = nil,
                                fireFirst flag: Bool = false,
                                @_inheritActorContext @_implicitSelfCapture
                                operations: @Sendable @escaping @isolated(any) () async -> Success) -> Self {
        Task(priority: priority) {
            if flag { await operations() }
            try await withDelay(duration, tolerance: tolerance, clock: clock, body: operations)
        }
    }
    
    /// Creates a new task that performs the given throwing operations after a specified delay.
    ///
    /// - Parameters:
    ///   - duration: The time to wait before executing the operations.
    ///   - tolerance: The allowed tolerance in scheduling the operations. Defaults to `nil`.
    ///   - clock: The clock to use for measuring time. Defaults to `ContinuousClock()`.
    ///   - priority: The priority of the created task. Defaults to `nil`.
    ///   - flag: Whether to execute the operations immediately before starting the delay. Defaults to `false`.
    ///   - operations: The closure containing the throwing operations to perform.
    /// - Returns: The created task.
    @discardableResult @inlinable
    static func delay<C: Clock>(_ duration: C.Instant.Duration,
                                tolerance: C.Instant.Duration? = nil,
                                clock: C = ContinuousClock(),
                                priority: TaskPriority? = nil,
                                fireFirst flag: Bool = false,
                                @_inheritActorContext @_implicitSelfCapture
                                operations: @Sendable @escaping @isolated(any) () async throws -> Success) -> Self {
        Task(priority: priority) {
            if flag { try await operations() }
            try await withDelay(duration, tolerance: tolerance, clock: clock, body: operations)
        }
    }
}

public extension Task where Failure == Error {
    /// Creates a new task that performs the given operations with a timeout.
    ///
    /// - Parameters:
    ///   - duration: The maximum time allowed for the operations to complete.
    ///   - tolerance: The allowed tolerance in scheduling the timeout. Defaults to `nil`.
    ///   - clock: The clock to use for measuring time. Defaults to `ContinuousClock()`.
    ///   - priority: The priority of the created task. Defaults to `nil`.
    ///   - operations: The closure containing the operations to perform.
    /// - Returns: The created task.
    @discardableResult @inlinable
    static func timeout<C: Clock>(_ duration: C.Instant.Duration,
                                  tolerance: C.Instant.Duration? = nil,
                                  clock: C = ContinuousClock(),
                                  priority: TaskPriority? = nil,
                                  @_inheritActorContext @_implicitSelfCapture
                                  operations: @Sendable @escaping @isolated(any) () async -> Success) -> Self {
        Task(priority: priority) {
            try await timeoutOperation(duration, tolerance: tolerance, clock: clock, body: operations)
        }
    }
    
    /// Creates a new task that performs the given throwing operations with a timeout.
    ///
    /// - Parameters:
    ///   - duration: The maximum time allowed for the operations to complete.
    ///   - tolerance: The allowed tolerance in scheduling the timeout. Defaults to `nil`.
    ///   - clock: The clock to use for measuring time. Defaults to `ContinuousClock()`.
    ///   - priority: The priority of the created task. Defaults to `nil`.
    ///   - operations: The closure containing the throwing operations to perform.
    /// - Returns: The created task.
    @discardableResult @inlinable
    static func timeout<C: Clock>(_ duration: C.Instant.Duration,
                                  tolerance: C.Instant.Duration? = nil,
                                  clock: C = ContinuousClock(),
                                  priority: TaskPriority? = nil,
                                  @_inheritActorContext @_implicitSelfCapture
                                  operations: @Sendable @escaping @isolated(any) () async throws -> Success) -> Self {
        Task(priority: priority) {
            try await timeoutOperation(duration, tolerance: tolerance, clock: clock, body: operations)
        }
    }
}

public extension Task where Failure == Error {
    /// Executes an operation with a specified timeout duration using a static method.
    ///
    /// This static method provides a convenient way to run an async operation with a timeout
    /// without requiring an existing Task instance.
    ///
    /// - Parameters:
    ///   - duration: The maximum time allowed for the operation to complete
    ///   - tolerance: Optional tolerance for the timeout timing, defaulting to nil
    ///   - clock: The clock to use for timing, defaults to ContinuousClock
    ///   - operations: The async operation to perform
    ///
    /// - Returns: The result of type T if the operation completes within the timeout
    ///
    /// - Throws: Throws a timeout error if the operation exceeds the specified duration
    ///
    /// - Complexity: O(1) for timeout setup, complexity of the operations closure varies
    ///
    /// - Note: The operation will be cancelled if it exceeds the timeout duration
    ///
    /// ```swift
    /// let result = try await Task.withTimeout(.seconds(5)) {
    ///     await someAsyncOperation()
    /// }
    /// ```
    @discardableResult @inlinable
    static func withTimeout<C: Clock, T: Sendable>(_ duration: C.Instant.Duration,
                                                   tolerance: C.Instant.Duration? = nil,
                                                   clock: C = ContinuousClock(),
                                                   @_inheritActorContext @_implicitSelfCapture
                                                   operations: @Sendable @escaping @isolated(any) () async -> T) async throws -> T {
        try await timeoutOperation(duration, tolerance: tolerance, clock: clock, body: operations)
    }
    
    /// Executes a throwing operation with a specified timeout duration using a static method.
    ///
    /// This static method provides a convenient way to run an async throwing operation with a timeout
    /// without requiring an existing Task instance.
    ///
    /// - Parameters:
    ///   - duration: The maximum time allowed for the operation to complete
    ///   - tolerance: Optional tolerance for the timeout timing, defaulting to nil
    ///   - clock: The clock to use for timing, defaults to ContinuousClock
    ///   - operations: The async throwing operation to perform
    ///
    /// - Returns: The result of type T if the operation completes within the timeout
    ///
    /// - Throws: Throws a timeout error if the operation exceeds the specified duration,
    ///           or any error thrown by the operations closure
    ///
    /// - Complexity: O(1) for timeout setup, complexity of the operations closure varies
    ///
    /// - Note: The operation will be cancelled if it exceeds the timeout duration
    ///
    /// ```swift
    /// let result = try await Task.withTimeout(.seconds(5)) {
    ///     try await someAsyncThrowingOperation()
    /// }
    /// ```
    @discardableResult @inlinable
    static func withTimeout<C: Clock, T: Sendable>(_ duration: C.Instant.Duration,
                                                   tolerance: C.Instant.Duration? = nil,
                                                   clock: C = ContinuousClock(),
                                                   @_inheritActorContext @_implicitSelfCapture
                                                   operations: @Sendable @escaping @isolated(any) () async throws -> T) async throws -> T {
        try await timeoutOperation(duration, tolerance: tolerance, clock: clock, body: operations)
    }
}

/// Executes the given body with a timeout.
///
/// This function creates a task group with two tasks: one for the main operation and one for the timeout.
/// If the main operation completes before the timeout, its result is returned. Otherwise, a `TaskTimeoutError` is thrown.
///
/// - Parameters:
///   - duration: The maximum time allowed for the body to complete.
///   - tolerance: The allowed tolerance in scheduling the timeout.
///   - clock: The clock to use for measuring time.
///   - body: The closure to execute.
/// - Returns: The result of the body if it completes within the timeout.
/// - Throws: `TaskTimeoutError` if the body doesn't complete within the timeout,
///           `CancellationError` if the task is cancelled, or any error thrown by the body.
@usableFromInline
func timeoutOperation<C: Clock, T: Sendable>(_ duration: C.Instant.Duration,
                                             tolerance: C.Instant.Duration?,
                                             clock: C,
                                             body: @Sendable @escaping @isolated(any) () async -> T) async throws -> T  {
    try await withThrowingTaskGroup(of: T.self, returning: T.self) { tg in
        guard tg.addTaskUnlessCancelled(operation: {
            let result = await body()
            try Task.checkCancellation()
            return result
        }) else { throw CancellationError() }
        
        guard tg.addTaskUnlessCancelled(operation: {
            try await Task.sleep(for: duration, tolerance: tolerance, clock: clock)
            try Task.checkCancellation()
            throw TaskTimeoutError()
        }) else { throw CancellationError() }
        
        guard let result = await tg.nextResult() else { throw CancellationError() }
        
        tg.cancelAll()
        
        return try result.get()
    }
}

/// Executes the given throwing body with a timeout.
///
/// This function creates a task group with two tasks: one for the main operation and one for the timeout.
/// If the main operation completes before the timeout, its result is returned. Otherwise, a `TaskTimeoutError` is thrown.
///
/// - Parameters:
///   - duration: The maximum time allowed for the body to complete.
///   - tolerance: The allowed tolerance in scheduling the timeout.
///   - clock: The clock to use for measuring time.
///   - body: The throwing closure to execute.
/// - Returns: The result of the body if it completes within the timeout.
/// - Throws: `TaskTimeoutError` if the body doesn't complete within the timeout,
///           `CancellationError` if the task is cancelled, or any error thrown by the body.
@usableFromInline
func timeoutOperation<C: Clock, T: Sendable>(_ duration: C.Instant.Duration,
                                             tolerance: C.Instant.Duration?,
                                             clock: C,
                                             body: @Sendable @escaping @isolated(any) () async throws -> T) async throws -> T  {
    try await withThrowingTaskGroup(of: T.self, returning: T.self) { tg in
        guard tg.addTaskUnlessCancelled(operation: {
            let result = try await body()
            try Task.checkCancellation()
            return result
        }) else { throw CancellationError() }
        
        guard tg.addTaskUnlessCancelled(operation: {
            try await Task.sleep(for: duration, tolerance: tolerance, clock: clock)
            try Task.checkCancellation()
            throw TaskTimeoutError()
        }) else { throw CancellationError() }
        
        guard let result = await tg.nextResult() else { throw CancellationError() }
        tg.cancelAll()
        
        return try result.get()
    }
}

/// Repeatedly executes the given body at the specified interval.
///
/// This function creates a stream of events occurring at the specified interval and executes the body for each event.
///
/// - Parameters:
///   - duration: The time interval between each execution of the body.
///   - tolerance: The allowed tolerance in scheduling the executions.
///   - clock: The clock to use for measuring time.
///   - body: The closure to execute repeatedly.
/// - Throws: Any error thrown by the waiting stream or the body.
@usableFromInline
func withRecurrence<C: Clock>(_ duration: C.Instant.Duration,
                              tolerance: C.Instant.Duration?,
                              clock: C,
                              body: @Sendable @escaping @isolated(any) () async -> ()) async throws {
    for try await _ in waitingStream(duration, tolerance: tolerance, clock: clock) {
        await body()
    }
}

/// Repeatedly executes the given throwing body at the specified interval.
///
/// This function creates a stream of events occurring at the specified interval and executes the body for each event.
///
/// - Parameters:
///   - duration: The time interval between each execution of the body.
///   - tolerance: The allowed tolerance in scheduling the executions.
///   - clock: The clock to use for measuring time.
///   - body: The throwing closure to execute repeatedly.
/// - Throws: Any error thrown by the waiting stream or the body.
@usableFromInline
func withRecurrence<C: Clock>(_ duration: C.Instant.Duration,
                              tolerance: C.Instant.Duration?,
                              clock: C,
                              body: @Sendable @escaping @isolated(any) () async throws -> ()) async throws {
    for try await _ in waitingStream(duration, tolerance: tolerance, clock: clock) {
        try await body()
    }
}

/// Executes the given body after a specified delay.
///
/// This function waits for the specified duration before executing the body.
///
/// - Parameters:
///   - duration: The time to wait before executing the body.
///   - tolerance: The allowed tolerance in scheduling the execution.
///   - clock: The clock to use for measuring time.
///   - body: The closure to execute after the delay.
/// - Throws: `CancellationError` if the task is cancelled during the delay.
@usableFromInline
func withDelay<C: Clock>(_ duration: C.Instant.Duration,
                         tolerance: C.Instant.Duration?,
                         clock: C,
                         body: @Sendable @escaping @isolated(any) () async -> ()) async throws {
    try await Task.sleep(for: duration, tolerance: tolerance, clock: clock)
    try Task.checkCancellation()
    await body()
}

/// Executes the given throwing body after a specified delay.
///
/// This function waits for the specified duration before executing the body.
///
/// - Parameters:
///   - duration: The time to wait before executing the body.
///   - tolerance: The allowed tolerance in scheduling the execution.
///   - clock: The clock to use for measuring time.
///   - body: The throwing closure to execute after the delay.
/// - Throws: `CancellationError` if the task is cancelled during the delay,
///           or any error thrown by the body.
@usableFromInline
func withDelay<C: Clock>(_ duration: C.Instant.Duration,
                         tolerance: C.Instant.Duration?,
                         clock: C,
                         body: @Sendable @escaping @isolated(any)  () async throws -> ()) async throws {
    try await Task.sleep(for: duration, tolerance: tolerance, clock: clock)
    try Task.checkCancellation()
    try await body()
}

private func waitingStream<C: Clock>(_ duration: C.Instant.Duration,
                                     tolerance: C.Instant.Duration?,
                                     clock: C) -> AsyncThrowingStream<Void, Error> {
    AsyncThrowingStream<Void, Error> {
        try await Task.sleep(for: duration, tolerance: tolerance, clock: clock)
    }
}
