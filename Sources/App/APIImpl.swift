import FluentKit
import HarnessDAL
import OpenAPIRuntime

struct APIImpl: APIProtocol {
    let database: any Database

    func listQuestions(
        _ input: Operations.listQuestions.Input
    ) async throws
        -> Operations.listQuestions.Output
    {
        let repository = QuestionRepository(database: database)
        let questions = try await repository.findAll()
        let sorted = questions.sorted { $0.code < $1.code }
        let response = sorted.map { question in
            Components.Schemas.Question(
                id: question.id ?? 0,
                code: question.code,
                prompt: question.prompt,
                questionType: .init(rawValue: question.questionType.rawValue)
                    ?? .string,
                helpText: question.helpText,
                insertedAt: question.insertedAt,
                updatedAt: question.updatedAt
            )
        }
        return .ok(.init(body: .json(response)))
    }
}
