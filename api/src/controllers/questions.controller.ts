import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
} from '@loopback/rest';
import {Questions} from '../models';
import {QuestionsRepository} from '../repositories';

export class QuestionsController {
  constructor(
    @repository(QuestionsRepository)
    public questionsRepository: QuestionsRepository,
  ) {}

  @post('/questions', {
    responses: {
      '200': {
        description: 'Questions model instance',
        content: {'application/json': {schema: getModelSchemaRef(Questions)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Questions, {
            title: 'NewQuestions',
            exclude: ['id'],
          }),
        },
      },
    })
    questions: Omit<Questions, 'id'>,
  ): Promise<Questions> {
    return this.questionsRepository.create(questions);
  }

  @get('/questions/count', {
    responses: {
      '200': {
        description: 'Questions model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(Questions) where?: Where<Questions>,
  ): Promise<Count> {
    return this.questionsRepository.count(where);
  }

  @get('/questions', {
    responses: {
      '200': {
        description: 'Array of Questions model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Questions, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(Questions) filter?: Filter<Questions>,
  ): Promise<Questions[]> {
    return this.questionsRepository.find(filter);
  }

  @patch('/questions', {
    responses: {
      '200': {
        description: 'Questions PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Questions, {partial: true}),
        },
      },
    })
    questions: Questions,
    @param.where(Questions) where?: Where<Questions>,
  ): Promise<Count> {
    return this.questionsRepository.updateAll(questions, where);
  }

  @get('/questions/{id}', {
    responses: {
      '200': {
        description: 'Questions model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(Questions, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(Questions, {exclude: 'where'})
    filter?: FilterExcludingWhere<Questions>,
  ): Promise<Questions> {
    return this.questionsRepository.findById(id, filter);
  }

  @patch('/questions/{id}', {
    responses: {
      '204': {
        description: 'Questions PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Questions, {partial: true}),
        },
      },
    })
    questions: Questions,
  ): Promise<void> {
    await this.questionsRepository.updateById(id, questions);
  }

  @put('/questions/{id}', {
    responses: {
      '204': {
        description: 'Questions PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() questions: Questions,
  ): Promise<void> {
    await this.questionsRepository.replaceById(id, questions);
  }

  @del('/questions/{id}', {
    responses: {
      '204': {
        description: 'Questions DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.questionsRepository.deleteById(id);
  }
}
