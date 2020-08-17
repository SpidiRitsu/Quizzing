import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {QuizToUser, Users} from '../models';
import {QuizToUserRepository} from '../repositories';

export class QuizToUserUsersController {
  constructor(
    @repository(QuizToUserRepository)
    public quizToUserRepository: QuizToUserRepository,
  ) {}

  @get('/quiz-to-users/{userId}/users', {
    responses: {
      '200': {
        description: 'Users belonging to QuizToUser',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async getUsers(
    @param.path.number('userId') userId: typeof QuizToUser.prototype.userId,
  ): Promise<Users> {
    return this.quizToUserRepository.user(userId);
  }
}
